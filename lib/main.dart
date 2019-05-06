import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/auth_page_bloc.dart';
import 'package:flutter_home_automation/blocs/home_page_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/blocs/room_page_bloc.dart';
import 'package:flutter_home_automation/pages/auth/login_page.dart';
import 'package:flutter_home_automation/pages/room_page.dart';
import 'package:flutter_home_automation/pages/splash_screen_page.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:flutter_home_automation/utils/route_handler.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:navigate/navigate.dart';
import './utils/native_calls.dart';

void registerRoutes() {
  Navigate.registerRoutes(
    routes: RouteHandler.routes,
    // defualtTransactionType: TransactionType.fadeIn,
  );
}

void main() async {
  registerRoutes();

  await FlutterStatusbarManager.setHidden(
    true,
    animation: StatusBarAnimation.SLIDE,
  );

  // await FlutterStatusbarManager.setFullscreen(true);
  // NativeCalls.startMotionDetectionSocketIOService();
  // NativeCalls.getDatafromAndroid();

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
