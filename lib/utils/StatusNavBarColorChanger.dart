import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class StatusNavBarColorChanger {
  static Future<void> changeStatusBarColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<void> changeNavBarColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setNavigationBarColor(color);
    } on Exception catch (e) {
      print(e);
    }
  }
}
