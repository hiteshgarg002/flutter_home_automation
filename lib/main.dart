import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_home_automation/pages/splash_screen_page.dart';
import 'package:flutter_home_automation/utils/native_calls.dart';
import 'package:flutter_home_automation/utils/route_handler.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:navigate/navigate.dart';

void registerRoutes() {
  Navigate.registerRoutes(
    routes: RouteHandler.routes,
    // defualtTransactionType: TransactionType.fadeIn,
  );
}

void main() async {
  // registering routes
  registerRoutes();

  // hiding statusbar
  await FlutterStatusbarManager.setHidden(
    true,
    animation: StatusBarAnimation.SLIDE,
  );

  // Setting app orientation to "Portrait"
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await FlutterStatusbarManager.setFullscreen(true);
  // NativeCalls.startMotionDetectionSocketIOService();
  // NativeCalls.getMotionDetectionStatus();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      // home: BlocProvider(
      //   bloc: HomePageBloc(),
      //   child: HomePage(),
      // ),
      // home: BlocProvider(
      //   bloc: AuthPageBloc(),
      //   child: LoginPage(),
      // ),
      home: SplashScreenPage(),                                                           
      // home: BlocProvider(
      //   bloc: RoomPageBloc(),
      //   child: RoomPage(),
      // ),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
        ),
      ),
    ),
  );
}
