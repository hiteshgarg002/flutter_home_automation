import 'package:flutter/services.dart';
import 'package:flutter_home_automation/blocs/monitor_page_bloc.dart';

class NativeCalls {
  static final MethodChannel _platformChannel =
      MethodChannel("flutter-home-automation");

  static Future startMotionDetectionSocketIOService() async {
    try {
      await _platformChannel
          .invokeMethod("startMotionDetectionSocketIOService");
    } catch (error) {
      print(error.toString());
    }
  }

  static Future stopMotionDetectionSocketIOService() async {
    try {
      await _platformChannel
          .invokeMethod("stopMotionDetectionSocketIOService");
    } catch (error) {
      print(error.toString());
    }
  }

  static void getMotionDetectionStatus(MonitorPageBloc monitorPageBloc) {
    final MethodChannel _channel = MethodChannel("flutter-home-automation-md");

    try {
      _channel.setMethodCallHandler((MethodCall call) {
        if (call.method == "getMotionDetectionStatus") {
          bool status = call.arguments.toString().toLowerCase() == "1"
              ? true
              : false;

          monitorPageBloc.setMotionDetectedStatus(status);
          print(" MD DATA in FLUTTER :- ${call.arguments}");
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }
}
