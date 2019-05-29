import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_home_automation/blocs/home_page_bloc.dart';
import 'package:flutter_home_automation/blocs/monitor_page_bloc.dart';
import 'package:flutter_home_automation/blocs/profile_dialog_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/connection.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:flutter_home_automation/utils/native_calls.dart';
import 'package:flutter_home_automation/widgets/profile_dialog.dart';
import 'package:navigate/navigate.dart';
import 'package:pigment/pigment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:xlive_switch/xlive_switch.dart';

class MonitorPage extends StatefulWidget {
  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  HomePageBloc _homePageBloc;
  MonitorPageBloc _monitorPageBloc;
  final String _detectedAnimation = "Error";
  final String _notDetectedAnimation = "Untitled";
  final String _detectedAnimationPath = "animations/fail.flr";
  final String _notDetectedAnimationPath = "animations/success.flr";
  final String _humidityHeroTag = "HUMIDITY";
  final String _lightIntensityHeroTag = "LIGHT_INTENSITY";
  final GlobalKey<ScaffoldState> _sfKey = GlobalKey<ScaffoldState>();
  SharedPreferences _prefs;
  double height, width;
  SocketIO _socketIO;

  @override
  void initState() {
    super.initState();

    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _monitorPageBloc = BlocProvider.of<MonitorPageBloc>(context);

    _setupSocketIO();
    _getWeather();

    NativeCalls.getMotionDetectionStatus(_monitorPageBloc);
  }

  Future _setUpSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    _monitorPageBloc.setSharedPreferences(_prefs);

    Map status = await NetworkCalls.getMotionDetectionEnabledStatus(
        _prefs.getString("userId"));

    _monitorPageBloc.setMotionDetectionEnabledStatus(status["status"] as bool);
  }

  Future _getWeather() async {
    _monitorPageBloc.setWeather(await NetworkCalls.getWeather());
  }

  Future<Null> _setupSocketIO() async {
    await _setUpSharedPreferences();

    SocketIOManager manager = SocketIOManager();
    _socketIO = await manager.createInstance('${DioAPI.baseURL}');

    _socketIO.onConnect((dynamic data) {
      print("SocketIO Connected :- MonitorPage");
      _socketIO.emit("join", [_prefs.getString("userId")]);
    });

    _socketIO.onReconnect((dynamic data) {
      _socketIO.emit("join", [_prefs.getString("userId")]);
    });

    _socketIO.onConnectTimeout((dynamic data) {
      print("MonitorPage :- SocketIO ConnectTimeout :- ${data.toString()}");
      _socketIO.connect();
    });

    _socketIO.onReconnectError((dynamic error) {
      print("MonitorPage :- SocketIO ReconnectError :- ${error.toString()}");
    });

    _socketIO.onError((dynamic error) {
      print("MonitorPage :- SocketIO Error :- ${error.toString()}");
      _socketIO.connect();
    });

    _socketIO.onReconnectFailed((dynamic error) {
      print("MonitorPage :- SocketIO ReconnectFailed :- ${error.toString()}");
    });

    _socketIO.on("reloadPhoto", (dynamic data) {
      _setUpSharedPreferences();
    });

    _socketIO.on("reloadName", (dynamic data) {
      _setUpSharedPreferences();
    });

    _socketIO.on("humidity", (dynamic data) {
      print("Hum :- $data");
      _monitorPageBloc.setHumidityData(data.toString());
    });

    _socketIO.on("temperature", (dynamic data) {
      print("temp :- $data");
      _monitorPageBloc.setTempData(data.toString());
    });

    _socketIO.on("lightintensity", (dynamic data) {
      print("li :- $data");
      _monitorPageBloc.setLIData((data / 10).toString());
    });

    _socketIO.connect();
  }

  Widget _buildHumidityCardWidget() {
    return Card(
      margin: EdgeInsets.all(
        ((1.354 * height) / 100),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ((2.032 * height) / 100),
        ),
      ),
      color: CustomColors.grey,
      elevation: ((0.606 * height) / 100),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
            top: ((2.032 * height) / 100),
            left: ((2.032 * height) / 100),
            right: ((2.032 * height) / 100),
            bottom: ((2.709 * height) / 100),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: "$_humidityHeroTag",
                      transitionOnUserGestures: true,
                      child: Image.asset(
                        "assets/humidity_2.png",
                        height: ((4.064 * height) / 100),
                        width: ((4.064 * height) / 100),
                      ),
                    ),
                    SizedBox(
                      height: ((2.709 * height) / 100),
                    ),
                    Text(
                      "HUMIDITY",
                      style: TextStyle(
                        fontFamily: 'CardName_Arial',
                        color: Pigment.fromString("#c9c7cd"),
                        fontSize: ((1.71 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<String>(
                      stream: _monitorPageBloc.getHumidityData,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return snapshot.hasData
                            ? Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ((6.096 * height) / 100),
                                ),
                              )
                            : Container(
                                height: ((2.0 * height) / 100),
                                width: ((2.0 * height) / 100),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 1.7,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              );
                      },
                    ),
                    Text(
                      "%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: ((2.980 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        splashColor: Colors.purple[300],
        highlightColor: CustomColors.darkPurple,
        onTap: () {
          Navigate.navigate(
            context,
            "/humidityPage",
            transactionType: TransactionType.fromRight,
          );
        },
      ),
    );
  }

  Widget _buildTemperatureCardWidget() {
    return Card(
      borderOnForeground: false,
      margin: EdgeInsets.all(
        ((1.354 * height) / 100),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ((2.032 * height) / 100),
        ),
      ),
      color: CustomColors.grey,
      elevation: ((0.406 * height) / 100),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
            top: ((2.032 * height) / 100),
            left: ((2.032 * height) / 100),
            right: ((2.032 * height) / 100),
            bottom: ((2.709 * height) / 100),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/temperature_1.png",
                      height: ((4.064 * height) / 100),
                      width: ((4.064 * height) / 100),
                    ),
                    SizedBox(
                      height: ((2.709 * height) / 100),
                    ),
                    Text(
                      "TEMPERATURE",
                      style: TextStyle(
                        fontFamily: 'CardName_Arial',
                        color: Pigment.fromString("#c9c7cd"),
                        fontSize: ((1.71 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<String>(
                      stream: _monitorPageBloc.getTempData,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return snapshot.hasData
                            ? Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ((6.096 * height) / 100),
                                ),
                              )
                            : Container(
                                height: ((2.0 * height) / 100),
                                width: ((2.0 * height) / 100),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 1.7,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              );
                      },
                    ),
                    Text(
                      "°C",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: ((2.980 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {},
        splashColor: Colors.purple[300],
        highlightColor: CustomColors.darkPurple,
      ),
    );
  }

  Widget _buildMotionDetectionCardWidget() {
    return Card(
      borderOnForeground: false,
      margin: EdgeInsets.all(
        ((1.354 * height) / 100),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ((2.032 * height) / 100),
        ),
      ),
      color: CustomColors.grey,
      elevation: ((0.406 * height) / 100),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
            top: ((2.032 * height) / 100),
            left: ((2.032 * height) / 100),
            right: ((2.032 * height) / 100),
            bottom: ((2.709 * height) / 100),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "assets/motion_detection.png",
                      height: ((4.064 * height) / 100),
                      width: ((4.064 * height) / 100),
                    ),
                    SizedBox(
                      height: ((2.709 * height) / 100),
                    ),
                    Text(
                      "MOTION DETECTION",
                      style: TextStyle(
                        fontFamily: 'CardName_Arial',
                        color: Pigment.fromString("#c9c7cd"),
                        fontSize: ((1.71 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: ((8.128 * height) / 100),
                  width: ((8.128 * height) / 100),
                  child: StreamBuilder<bool>(
                    initialData: false,
                    stream: _monitorPageBloc.getMotionDetectionEnabledStatus,
                    builder: (BuildContext context,
                        AsyncSnapshot<bool> enabledSnapshot) {
                      if (enabledSnapshot.data) {
                        NativeCalls.startMotionDetectionSocketIOService();

                        return StreamBuilder<bool>(
                          initialData: false,
                          stream: _monitorPageBloc.getMotionDetectedStatus,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> motionDetectionSnapshot) {
                            return FlareActor(
                              motionDetectionSnapshot.data
                                  ? _detectedAnimationPath
                                  : _notDetectedAnimationPath,
                              animation: motionDetectionSnapshot.data
                                  ? _detectedAnimation
                                  : _notDetectedAnimation,
                              alignment: Alignment.centerLeft,
                            );
                          },
                        );
                      } else {
                        NativeCalls.stopMotionDetectionSocketIOService();

                        return AvatarGlow(
                          glowColor: Colors.red,
                          repeat: true,
                          showTwoGlows: true,
                          endRadius: 35.0,
                          child: Icon(
                            Icons.warning,
                            color: Colors.orange,
                            size: 35.0,
                          ),
                        );
                      }

                      // return enabledSnapshot.data
                      //     ? StreamBuilder<bool>(
                      //         initialData: false,
                      //         stream: _monitorPageBloc.getMotionDetectedStatus,
                      //         builder: (BuildContext context,
                      //             AsyncSnapshot<bool> motionDetectionSnapshot) {
                      //           return FlareActor(
                      //             motionDetectionSnapshot.data
                      //                 ? _detectedAnimationPath
                      //                 : _notDetectedAnimationPath,
                      //             animation: motionDetectionSnapshot.data
                      //                 ? _detectedAnimation
                      //                 : _notDetectedAnimation,
                      //             alignment: Alignment.centerLeft,
                      //           );
                      //         },
                      //       )
                      //     : AvatarGlow(
                      //         glowColor: Colors.red,
                      //         repeat: true,
                      //         showTwoGlows: true,
                      //         endRadius: 35.0,
                      //         child: Icon(
                      //           Icons.warning,
                      //           color: Colors.orange,
                      //           size: 35.0,
                      //         ),
                      //       );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {},
        splashColor: Colors.purple[300],
        highlightColor: CustomColors.darkPurple,
      ),
    );
  }

  Widget _buildLightIntensityCardWidget() {
    return Card(
      borderOnForeground: false,
      margin: EdgeInsets.all(
        ((1.354 * height) / 100),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ((2.032 * height) / 100),
        ),
      ),
      color: CustomColors.grey,
      elevation: ((0.406 * height) / 100),
      child: InkWell(
        child: Container(
          padding: EdgeInsets.only(
            top: ((2.032 * height) / 100),
            left: ((2.032 * height) / 100),
            right: ((2.032 * height) / 100),
            bottom: ((2.709 * height) / 100),
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: "$_lightIntensityHeroTag",
                      transitionOnUserGestures: true,
                      child: Image.asset(
                        "assets/bulb.png",
                        height: ((4.064 * height) / 100),
                        width: ((4.064 * height) / 100),
                      ),
                    ),
                    SizedBox(
                      height: ((2.709 * height) / 100),
                    ),
                    Text(
                      "LIGHT INTENSITY",
                      style: TextStyle(
                        fontFamily: 'CardName_Arial',
                        color: Pigment.fromString("#c9c7cd"),
                        fontSize: ((1.71 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<String>(
                      stream: _monitorPageBloc.getLIData,
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        return snapshot.hasData
                            ? Text(
                                "${snapshot.data}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ((6.096 * height) / 100),
                                ),
                              )
                            : Container(
                                height: ((2.0 * height) / 100),
                                width: ((2.0 * height) / 100),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 1.7,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              );
                      },
                    ),
                    Text(
                      "%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: ((2.980 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        splashColor: Colors.purple[300],
        highlightColor: CustomColors.darkPurple,
        onTap: () {
          Navigate.navigate(
            context,
            "/lightIntensityPage",
            transactionType: TransactionType.fromRight,
          );
        },
      ),
    );
  }

  Widget _buildAppBarUserPhotoWidget(double bigRadius, double smallRadius) {
    return StreamBuilder<SharedPreferences>(
      stream: _monitorPageBloc.getSharedPreferences,
      builder: (BuildContext context,
          AsyncSnapshot<SharedPreferences> prefsSnapshot) {
        if (prefsSnapshot.hasData) {
          String photoUrl = prefsSnapshot.data.getString("photoUrl");
          String name = prefsSnapshot.data.getString("name");

          return GestureDetector(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: bigRadius,
              child: photoUrl.isNotEmpty
                  ? CircleAvatar(
                      radius: smallRadius,
                      backgroundColor: Colors.white,
                      backgroundImage: CachedNetworkImageProvider(
                        "${DioAPI.baseURL}/$photoUrl",
                        cacheManager: DefaultCacheManager(),
                      ),
                    )
                  : Center(
                      child: Text(
                        name.contains(" ")
                            ? "${name.substring(0, 1)}${name.split(" ")[1].substring(0, 1)}"
                            : "${name.substring(0, 1)}",
                        style: TextStyle(
                          color: CustomColors.darkestGrey,
                          fontSize: ((2.167 * height) / 100),
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlocProvider(
                    bloc: ProfileDialogBloc(),
                    child: ProfileDialog(),
                  );
                },
              );
            },
          );
        } else {
          return CircleAvatar(
            backgroundColor: Colors.white,
            radius: bigRadius,
          );
        }
      },
    );
  }

  Widget _buildCustomAppBar() {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      centerTitle: false,
      titlePadding: EdgeInsets.all(
        0.0,
      ),
      title: StreamBuilder<bool>(
        initialData: false,
        stream: _homePageBloc.getCollapsedAppBatStatus,
        builder: (BuildContext context,
            AsyncSnapshot<bool> collapsedAppBarSnapshot) {
          return !collapsedAppBarSnapshot.data
              ? Container()
              : Container(
                  color: Colors.transparent,
                  width: width,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(((1.083 * height) / 100)),
                          child: _buildAppBarUserPhotoWidget(
                              ((2.641 * height) / 100),
                              ((2.506 * height) / 100)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          iconSize: ((3.251 * height) / 100),
                          icon: Icon(
                            Icons.notifications_none,
                            color: Pigment.fromString("#c9c7cd"),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      background: Stack(
        children: <Widget>[
          Image.asset(
            "assets/night_with_moon.jpg",
            height: height * 0.35,
            width: width,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black38,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: ((1.219 * height) / 100),
                    top: ((1.354 * height) / 100),
                    right: ((0.677 * height) / 100),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: _buildAppBarUserPhotoWidget(
                            ((2.844 * height) / 100), ((2.709 * height) / 100)),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          iconSize: ((3.251 * height) / 100),
                          icon: Icon(
                            Icons.notifications_none,
                            color: Pigment.fromString("#c9c7cd"),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ((2.709 * height) / 100),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ((3.386 * height) / 100),
                  ),
                  child: Text(
                    "Good day!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ((4.064 * height) / 100),
                    ),
                  ),
                ),
                SizedBox(
                  height: ((0.677 * height) / 100),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ((3.386 * height) / 100),
                  ),
                  child: StreamBuilder<SharedPreferences>(
                    stream: _monitorPageBloc.getSharedPreferences,
                    builder: (BuildContext context,
                        AsyncSnapshot<SharedPreferences> prefsSnapshot) {
                      String name = prefsSnapshot.hasData
                          ? prefsSnapshot.data.getString("name").contains(" ")
                              ? "${prefsSnapshot.data.getString("name").split(" ")[0]}!"
                              : "${prefsSnapshot.data.getString("name")}!"
                          : "";

                      return Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ((2.709 * height) / 100),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: ((4.064 * height) / 100),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ((3.386 * height) / 100),
                  ),
                  child: _buildWeatherIconTemperatureWidget(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: ((3.386 * height) / 100),
                  ),
                  child: Text(
                    "Gwalior",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ((1.896 * height) / 100),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeatherIconTemperatureWidget() {
    return StreamBuilder<Map<String, dynamic>>(
      initialData: <String, dynamic>{"waiting": true},
      stream: _monitorPageBloc.getWeather,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> weatherSnapshot) {
        if (!(weatherSnapshot.data.containsKey("waiting"))) {
          dynamic temperature = weatherSnapshot.data["current"]["temp_c"];
          String iconURL = weatherSnapshot.data["current"]["condition"]["icon"];

          return Row(
            children: <Widget>[
              FadeInImage.assetNetwork(
                image: "https:$iconURL",
                placeholder: "assets/sunny.png",
                height: ((4.415 * height) / 100),
                width: ((4.415 * height) / 100),
              ),
              Text(
                "$temperature°C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ((2.167 * height) / 100),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(bottom: ((2.438 * height) / 100)),
            child: Container(
              height: ((2.0 * height) / 100),
              width: ((2.0 * height) / 100),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 1.7,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildSliverAppBarWidget() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: height * 0.35,
      leading: Container(),
      elevation: 0.0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          constraints.biggest.height == (56.0)
              ? _homePageBloc.setCollapsedAppBarStatus(true)
              : _homePageBloc.setCollapsedAppBarStatus(false);

          return _buildCustomAppBar();
        },
      ),
    );
  }

  // Widget _buildRoomDropDownWidget() {
  //   return DropdownButtonHideUnderline(
  //     child: DropdownButton(
  //       hint: Text("-- ROOM --"),
  //       iconSize: ((3.251 * height) / 100),
  //       style: TextStyle(
  //         color: Colors.black,
  //       ),
  //       isExpanded: false,
  //       items: <DropdownMenuItem>[
  //         DropdownMenuItem(
  //           child: Chip(
  //             backgroundColor: Colors.white,
  //             label: Text(
  //               "Home",
  //               style: TextStyle(
  //                 fontSize: ((2.032 * height) / 100),
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //         DropdownMenuItem(
  //           child: Chip(
  //             backgroundColor: Colors.white,
  //             label: Text(
  //               "Living Room",
  //               style: TextStyle(
  //                 fontSize: ((2.032 * height) / 100),
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //         DropdownMenuItem(
  //           child: Chip(
  //             backgroundColor: Colors.white,
  //             label: Text(
  //               "Dinning Room",
  //               style: TextStyle(
  //                 fontSize: ((2.032 * height) / 100),
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //         DropdownMenuItem(
  //           child: Chip(
  //             backgroundColor: Colors.white,
  //             label: Text(
  //               "Kitchen",
  //               style: TextStyle(
  //                 fontSize: ((2.032 * height) / 100),
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //       onChanged: (value) {},
  //     ),
  //   );
  // }

  Widget _buildHomeMotionDetectionSliverWidget() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _homePageBloc.getCollapsedAppBatStatus,
      builder:
          (BuildContext context, AsyncSnapshot<bool> collapsedAppBarSnapshot) {
        return SliverAppBar(
          leading: Container(),
          backgroundColor: collapsedAppBarSnapshot.data
              ? CustomColors.grey
              : CustomColors.darkGrey,
          elevation:
              collapsedAppBarSnapshot.data ? ((0.406 * height) / 100) : 0.0,
          pinned: true,
          flexibleSpace: PreferredSize(
            preferredSize: Size.fromWidth(width),
            // Row is used because DropdownButton was taking full width otherwise.
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: ((1.083 * height) / 100),
                    left: ((2.032 * height) / 100),
                    bottom: ((1.083 * height) / 100),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.white,
                      brightness: Brightness.dark,
                    ),
                    child: Chip(
                      backgroundColor: Colors.white,
                      label: Text(
                        "Home",
                        style: TextStyle(
                          fontSize: ((2.032 * height) / 100),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // child: _buildRoomDropDownWidget(),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  "Motion Detection",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: ((1.083 * height) / 100),
                    right: ((2.032 * height) / 100),
                    bottom: ((1.083 * height) / 100),
                  ),
                  child: _buildMotionDetectionToggleWidget(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMotionDetectionToggleWidget() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _monitorPageBloc.getMotionDetectionEnabledStatus,
      builder: (BuildContext context, AsyncSnapshot<bool> enabledSapshot) {
        return XlivSwitch(
          activeColor: Colors.lightBlue,
          unActiveColor: Colors.white,
          thumbColor: Colors.black45,
          value: enabledSapshot.data,
          onChanged: _onMotionDetectionToggleStatusChange,
        );
      },
    );
  }

  Future _onMotionDetectionToggleStatusChange(bool status) async {
    if (await Connection.isConnected()) {
      _monitorPageBloc.setMotionDetectionEnabledStatus(status);

      bool statusRes = await NetworkCalls.setMotionDetectionEnabledStatus(
          _prefs.getString("userId"), status);

      _monitorPageBloc.setMotionDetectionEnabledStatus(statusRes);
    } else {
      _sfKey.currentState.showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning,
                color: Colors.black,
                size: 24.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Network unavailable!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildSliverGridWidget() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      delegate: SliverChildListDelegate(
        <Widget>[
          _buildHumidityCardWidget(),
          _buildTemperatureCardWidget(),
          _buildMotionDetectionCardWidget(),
          _buildLightIntensityCardWidget(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    // print("18 is the ${(18 * 100) / height}% of Height :- $height");

    return Scaffold(
      key: _sfKey,
      backgroundColor: CustomColors.darkGrey,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBarWidget(),
          _buildHomeMotionDetectionSliverWidget(),
          SliverPadding(
            padding: EdgeInsets.only(
              top: ((2.032 * height) / 100),
              left: ((1.354 * height) / 100),
              right: ((1.354 * height) / 100),
              bottom: ((1.354 * height) / 100),
            ),
            sliver: _buildSliverGridWidget(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_socketIO != null) {
      _socketIO.off("reloadPhoto");
      _socketIO.off("reloadName");
      _socketIO.off("lightintensity");
      _socketIO.off("humidity");
      _socketIO.off("temperature");

      _socketIO.emit('dis', [_prefs.getString("userId")]);
    }
    super.dispose();
  }
}
