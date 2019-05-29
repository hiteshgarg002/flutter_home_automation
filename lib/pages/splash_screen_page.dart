import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/connection.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:navigate/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SharedPreferences _prefs;
  double height, width;

  @override
  void initState() {
    Timer(
      Duration(seconds: 5),
      _makeRedirect,
    );

    super.initState();
  }

  void _makeRedirect() async {
    await _setupSharedPreferences();

    if (_prefs.containsKey("intro_done")) {
      if (_prefs.containsKey("email")) {
        if (await Connection.isConnected()) {
          await _login();
        } else {
          if (Platform.isAndroid) {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          } else {
            exit(0);
          }
        }
      } else {
        await Navigate.navigate(
          context,
          "/loginPage",
          transactionType: TransactionType.fromRight,
          replaceRoute: ReplaceRoute.all,
        );
      }
    } else {
      await Navigate.navigate(
        context,
        "/introSliderPage",
        transactionType: TransactionType.fadeIn,
        replaceRoute: ReplaceRoute.thisOne,
      );
    }
  }

  Future _login() async {
    Map<String, String> userData = {
      "email": _prefs.getString("email"),
      "password": _prefs.getString("password"),
    };

    Map response = await NetworkCalls.login(userData);

    if (response.containsKey("error")) {
      await Navigate.navigate(
        context,
        "/loginPage",
        transactionType: TransactionType.fromRight,
        replaceRoute: ReplaceRoute.all,
      );
    } else {
      await _saveUserInfo(response["user"]);

      await Navigate.navigate(
        context,
        "/homePage",
        transactionType: TransactionType.fromRight,
        replaceRoute: ReplaceRoute.all,
      );
    }
  }

  Future _saveUserInfo(Map response) async {
    await _prefs.setString("email", response["email"]);
    await _prefs.setString("password", response["password"]);
    await _prefs.setInt("phone", response["phone"]);
    await _prefs.setString("name", response["name"]);
    await _prefs.setString("photoUrl", response["photoUrl"]);
    await _prefs.setString("userId", response["_id"]);
    await _prefs.setString("homeId", response["homeId"]);
  }

  Future _setupSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(CustomColors.darkGrey);

    return Scaffold(
      backgroundColor: CustomColors.darkGrey,
      body: Center(
        child: Image(
          image: AssetImage("assets/bulb_gif.gif"),
          height: height * 0.25,
        ),
      ),
    );
  }
}
