//package com.example.flutter_home_automation;
//
//import android.app.Service;
//import android.content.Context;
//import android.content.Intent;
//import android.os.IBinder;
//import android.util.Log;
//
//import androidx.annotation.Nullable;
//
//import com.github.nkzawa.emitter.Emitter;
//import com.github.nkzawa.socketio.client.IO;
//import com.github.nkzawa.socketio.client.Socket;
//
//import java.net.URISyntaxException;
//import java.util.Timer;
//import java.util.TimerTask;
//
//public class MotionDetectionService extends Service {
//    private Context ctx;
//    private Socket socket;
//    private Intent mIntent;
//    final static private String INTENT_ACTION = "com.flutter.homeautomation";
//
//    private Emitter.Listener motionDetectionListener = args -> {
//        String data = (String) args[0];
//        mIntent = new Intent(INTENT_ACTION);
//
//        mIntent.putExtra("data", data);
//        ctx.sendBroadcast(mIntent);
//
//        socket.emit("md", data);
//
//    };
//
//    @Override
//    public void onCreate() {
//        super.onCreate();
//        ctx = getApplicationContext();
//
//        try {
//            socket = IO.socket("http://192.168.43.222:8080");
//        } catch (URISyntaxException e) {
//            Log.d("ERROR", e.getMessage());
//        }
//        socket.on("motion_detection", motionDetectionListener);
//        socket.connect();
//    }
//
//    @Nullable
//    @Override
//    public IBinder onBind(Intent intent) {
//        return null;
//    }
//
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        super.onStartCommand(intent, flags, startId);
//        return START_STICKY;
//    }
//
//    @Override
//    public void onTaskRemoved(Intent rootIntent) {
//        stopSelf();
//        Log.e("stopservice", "stopServices");
//        try {
//            Thread.sleep(100);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//        super.onTaskRemoved(rootIntent);
//    }
//
//    @Override
//    public void onDestroy() {
//        super.onDestroy();
//        Intent broadcastIntent = new Intent(INTENT_ACTION);
//        broadcastIntent.putExtra("stopped",true);
//        ctx.sendBroadcast(broadcastIntent);
//    }
//}


package com.example.flutter_home_automation;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.graphics.Color;
import android.os.Build;
import android.os.IBinder;
import android.os.SystemClock;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

import com.github.nkzawa.emitter.Emitter;
import com.github.nkzawa.socketio.client.IO;
import com.github.nkzawa.socketio.client.Socket;

import java.net.URISyntaxException;
import java.util.Timer;
import java.util.TimerTask;

public class MotionDetectionService extends Service {
    private Context ctx;
    private Socket socket;
    private Intent mIntent;
    // public int counter=0;
    final static private String INTENT_ACTION = "com.flutter.homeautomation";

    private Emitter.Listener motionDetectionListener = args -> {
        String data = (String) args[0];
        mIntent = new Intent(INTENT_ACTION);

        mIntent.putExtra("data", data);
        ctx.sendBroadcast(mIntent);

//        socket.emit("md", data);

    };

    @Override
    public void onCreate() {
        super.onCreate();
        ctx = getApplicationContext();

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O)
            startMyOwnForeground();
        else
            startForeground(1, new Notification());

        try {
            socket = IO.socket("http://192.168.43.222:8080");
        } catch (URISyntaxException e) {
            Log.d("ERROR", e.getMessage());
        }
        socket.on("motiondetection", motionDetectionListener);
        socket.connect();
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private void startMyOwnForeground() {
        String NOTIFICATION_CHANNEL_ID = "home.automation";
        String channelName = "Background Service";
        NotificationChannel chan = new NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_NONE);
        chan.setLightColor(Color.BLUE);
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE);

        NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        assert manager != null;
        manager.createNotificationChannel(chan);

        NotificationCompat.Builder notificationBuilder = new NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID);
        Notification notification = notificationBuilder.setOngoing(true)
                .setContentTitle("")
                .setPriority(NotificationManager.IMPORTANCE_MIN)
                .setCategory(Notification.CATEGORY_SERVICE)
                .build();
        startForeground(2, notification);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
        startTimer();
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        stoptimertask();

        Intent broadcastIntent = new Intent();
        broadcastIntent.setAction("restartservice");
        broadcastIntent.setClass(this, Restarter.class);
        this.sendBroadcast(broadcastIntent);
    }

    private Timer timer;
    private TimerTask timerTask;

    public void startTimer() {
        timer = new Timer();
        timerTask = new TimerTask() {
            public void run() {
                // Log.i("Count", "=========  "+ (counter++));
            }
        };
        timer.schedule(timerTask, 1000, 1000);
    }

    public void stoptimertask() {
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Log.e("FLAGX : ", ServiceInfo.FLAG_STOP_WITH_TASK + "");
        Intent restartServiceIntent = new Intent(getApplicationContext(),
                this.getClass());
        restartServiceIntent.setPackage(getPackageName());

        PendingIntent restartServicePendingIntent = PendingIntent.getService(
                getApplicationContext(), 1, restartServiceIntent,
                PendingIntent.FLAG_ONE_SHOT);
        AlarmManager alarmService = (AlarmManager) getApplicationContext()
                .getSystemService(Context.ALARM_SERVICE);
        alarmService.set(AlarmManager.ELAPSED_REALTIME,
                SystemClock.elapsedRealtime() + 1000,
                restartServicePendingIntent);

        super.onTaskRemoved(rootIntent);
    }
}
