import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_home_automation/blocs/home_page_bloc.dart';
import 'package:flutter_home_automation/blocs/monitor_page_bloc.dart';
import 'package:flutter_home_automation/blocs/profile_dialog_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:flutter_home_automation/widgets/profile_dialog.dart';
import 'package:navigate/navigate.dart';
import 'package:pigment/pigment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  SharedPreferences _prefs;
  double height, width;
  SocketIO _socketIO;

  @override
  void initState() {
    super.initState();

    _homePageBloc = BlocProvider.of<HomePageBloc>(context);
    _monitorPageBloc = BlocProvider.of<MonitorPageBloc>(context);

    _getReloadPhotoIO();
  }

  Future _setUpSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();

    _monitorPageBloc.setSharedPreferences(_prefs);
  }

  Future<Null> _getReloadPhotoIO() async {
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
                    Text(
                      "26",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ((6.096 * height) / 100),
                      ),
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
                    Text(
                      "22",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ((6.096 * height) / 100),
                      ),
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
                    Text(
                      "50",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ((6.096 * height) / 100),
                      ),
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
                    "Goodevening!",
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
                              : "${prefsSnapshot.data.getString("name")}"
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
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.cloud_queue,
                        color: Colors.white,
                        size: ((3.115 * height) / 100),
                      ),
                      SizedBox(
                        width: ((1.083 * height) / 100),
                      ),
                      Text(
                        "16°C",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ((2.167 * height) / 100),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
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

  Widget _buildRoomDropDownWidget() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: Text("-- ROOM --"),
        iconSize: ((3.251 * height) / 100),
        style: TextStyle(
          color: Colors.black,
        ),
        isExpanded: false,
        items: <DropdownMenuItem>[
          DropdownMenuItem(
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
          ),
          DropdownMenuItem(
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(
                "Living Room",
                style: TextStyle(
                  fontSize: ((2.032 * height) / 100),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          DropdownMenuItem(
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(
                "Dinning Room",
                style: TextStyle(
                  fontSize: ((2.032 * height) / 100),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          DropdownMenuItem(
            child: Chip(
              backgroundColor: Colors.white,
              label: Text(
                "Kitchen",
                style: TextStyle(
                  fontSize: ((2.032 * height) / 100),
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildRoomDropDownSliverWidget() {
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
                    child: _buildRoomDropDownWidget(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

    return Scaffold(
      backgroundColor: CustomColors.darkGrey,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildSliverAppBarWidget(),
          _buildRoomDropDownSliverWidget(),
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
      _socketIO.off("reloadPhoto", (dynamic data) {
        print("SocketIO Disconnected :- MonitorPage");
      });
    }
    super.dispose();
  }
}
