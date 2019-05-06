import 'package:flutter/services.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

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

  // getting data sent from android through invokeMethod in android and setMethodCallHandler in flutter
  static void getDatafromAndroid() {
    final MethodChannel _channel =
        MethodChannel("flutter-home-automation-testing");

    try {
      _channel.setMethodCallHandler((MethodCall call) {
        if (call.method == "testing") {
          print("Y dkho re data :- ${call.arguments}");
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }
}
