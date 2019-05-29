package com.example.flutter_home_automation;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter-home-automation";
    private final static String INTENT_ACTION = "com.flutter.homeautomation";
    private Context ctx;
    private MethodChannel methodChannel;
    private Intent mServiceIntent;
    private MotionDetectionService mYourService;
    private MediaPlayer mp;

    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getStringExtra("data").equalsIgnoreCase("1")) {
             setupAlertSound();
            } else if (intent.getStringExtra("data").equalsIgnoreCase("0")) {
                if (mp != null && mp.isPlaying()) {
                    mp.stop();
                }
            }

            System.out.println("DATA :- " + intent.getStringExtra("data"));
            new MethodChannel(getFlutterView(), "flutter-home-automation-md").invokeMethod("getMotionDetectionStatus", intent.getStringExtra("data") + "");
        }
    };


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ctx = this;

        methodChannel = new MethodChannel(getFlutterView(), CHANNEL);
        methodChannel.setMethodCallHandler((MethodCall methodCall, MethodChannel.Result result) -> {
            if (methodCall.method.equals("startMotionDetectionSocketIOService")) {
//                ctx.startService(new Intent(getApplicationContext(), MotionDetectionService.class));
                mYourService = new MotionDetectionService();
                mServiceIntent = new Intent(this, mYourService.getClass());
                if (!isMyServiceRunning(mYourService.getClass())) {
                    startService(mServiceIntent);
                }
            }

            if (methodCall.method.equals("stopMotionDetectionSocketIOService")) {
                mYourService = new MotionDetectionService();
                mServiceIntent = new Intent(this, mYourService.getClass());
                if (isMyServiceRunning(mYourService.getClass())) {
                    stopService(mServiceIntent);

                    if (mp != null && mp.isPlaying()) {
                        mp.stop();
                    }
                }
            }
        });

//        setupAlertSound();

        GeneratedPluginRegistrant.registerWith(this);
    }

    @Override
    protected void onStart() {
        super.onStart();
        ctx.registerReceiver(broadcastReceiver, new IntentFilter(INTENT_ACTION));
    }

    @Override
    protected void onResume() {
        super.onResume();
        ctx.registerReceiver(broadcastReceiver, new IntentFilter(INTENT_ACTION));
    }

    @Override
    protected void onRestart() {
        super.onRestart();
        ctx.registerReceiver(broadcastReceiver, new IntentFilter(INTENT_ACTION));
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        ctx.registerReceiver(broadcastReceiver, new IntentFilter(INTENT_ACTION));
    }

    private void setupAlertSound() {
//        Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);
//        Ringtone r = RingtoneManager.getRingtone(getApplicationContext(), notification);
//        r.play();
        MediaPlayer mpAlert = MediaPlayer.create(getApplicationContext(), R.raw.alert);
        mpAlert.setOnPreparedListener(this::onPrepared);
        mpAlert.setLooping(false);
    }

    private void onPrepared(MediaPlayer player) {
        mp=player;
        if(!player.isPlaying()) {
            player.start();
        }
    }

    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                Log.i("Service status", "Running");
                return true;
            }
        }
        Log.i("Service status", "Not running");
        return false;
    }


    @Override
    protected void onDestroy() {
        stopService(mServiceIntent);
        super.onDestroy();
    }
}
