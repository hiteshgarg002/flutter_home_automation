import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/add_appliance_page_bloc.dart';
import 'package:flutter_home_automation/blocs/auth_page_bloc.dart';
import 'package:flutter_home_automation/blocs/home_page_bloc.dart';
import 'package:flutter_home_automation/blocs/monitor_page_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/blocs/room_page_bloc.dart';
import 'package:flutter_home_automation/pages/add_appliance_page.dart';
import 'package:flutter_home_automation/pages/appliance_settings_page.dart';
import 'package:flutter_home_automation/pages/auth/login_page.dart';
import 'package:flutter_home_automation/pages/home_page.dart';
import 'package:flutter_home_automation/pages/humidity_page.dart';
import 'package:flutter_home_automation/pages/intro_slider_page.dart';
import 'package:flutter_home_automation/pages/light_intensity_page.dart';
import 'package:flutter_home_automation/pages/motion_detection_page.dart';
import 'package:flutter_home_automation/pages/room_page.dart';
import 'package:flutter_home_automation/pages/room_timeline_page.dart';
import 'package:flutter_home_automation/pages/temperature_page.dart';
import 'package:navigate/navigate.dart';

class RouteHandler {
  static var _humidityPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return BlocProvider(
        bloc: MonitorPageBloc(),
        child: HumidityPage(),
      );
    },
  );

  static var _temperaturePageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return TemperaturePage();
    },
  );

  static var _motionDetectionPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return MotionDetectionPage();
    },
  );

  static var _lightIntensityPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return BlocProvider(
        bloc: MonitorPageBloc(),
        child: LightIntensityPage(),
      );
    },
  );

  static var _roomPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return BlocProvider(
        bloc: RoomPageBloc(),
        child: RoomPage(
          roomId: args["roomId"],
          reloadRooms: args["reloadRooms"],
        ),
      );
    },
  );

  static var _applianceSettingsPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return ApplianceSettingsPage(
        applianceData: args as Map,
      );
    },
  );

  static var _roomTimelinePageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return RoomTimelinePage(
        roomTimelineHeroTag: args.toString(),
      );
    },
  );

  static var _loginPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      Map<String, String> data = args;

      return BlocProvider(
        bloc: AuthPageBloc(),
        child: data != null && data.containsKey("email")
            ? LoginPage(
                email: data["email"],
                password: data["password"],
              )
            : LoginPage(),
      );
    },
  );

  static var _introSliderPageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return IntroSliderPage();
    },
  );

  static var _homePageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return BlocProvider(
        bloc: HomePageBloc(),
        child: HomePage(),
      );
    },
  );

  static var _addAppliancePageHandler = Handler(
    pageBuilder: (BuildContext context, dynamic args) {
      return BlocProvider(
        bloc: AddAppliancePageBloc(),
        child: AddAppliancePage(
          roomId: args["roomId"],
          reloadRoom: args["reloadRoom"],
        ),
      );
    },
  );

  static Map<String, Handler> _routes = {
    "/humidityPage": _humidityPageHandler,
    "/temperaturePage": _temperaturePageHandler,
    "/motionDetectionPage": _motionDetectionPageHandler,
    "/lightIntensityPage": _lightIntensityPageHandler,
    "/roomPage": _roomPageHandler,
    "/applianceSettingsPage": _applianceSettingsPageHandler,
    "/roomTimelinePage": _roomTimelinePageHandler,
    "/loginPage": _loginPageHandler,
    "/introSliderPage": _introSliderPageHandler,
    "/homePage": _homePageHandler,
    "/addAppliancePage": _addAppliancePageHandler,
  };

  static Map<String, Handler> get routes => _routes;
}
