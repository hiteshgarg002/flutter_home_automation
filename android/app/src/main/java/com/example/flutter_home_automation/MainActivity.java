package com.example.flutter_home_automation;

import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.Ringtone;
import android.media.RingtoneManager;
import android.net.Uri;
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
    Intent mServiceIntent;
    private MotionDetectionService mYourService;

    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
//            playSound();
            System.out.println("DATA :- " + intent.getStringExtra("data"));
            new MethodChannel(getFlutterView(), "flutter-home-automation-testing").invokeMethod("testing", intent.getStringExtra("data") + "");
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
        });

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

    private void playSound() {
        Uri notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM);
        Ringtone r = RingtoneManager.getRingtone(getApplicationContext(), notification);
        r.play();
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
