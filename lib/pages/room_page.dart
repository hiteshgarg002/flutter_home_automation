import 'dart:async';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/blocs/room_page_bloc.dart';
import 'package:flutter_home_automation/models/appliance_model.dart';
import 'package:flutter_home_automation/models/room_model.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:navigate/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlive_switch/xlive_switch.dart';

class RoomPage extends StatefulWidget {
  final String roomId;

  RoomPage({
    @required this.roomId,
  });

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final String _roomTimelineHeroTag = "ROOM_TIMELINE_HERO_TAG";
  RoomPageBloc _roomPageBloc;
  final String _addButtonTag = "ADD_APPLIANCE";
  PageController _appliancesPageContoller;
  RoomModel _roomModel;
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();

    _roomPageBloc = BlocProvider.of<RoomPageBloc>(context);
    _getRoom();

    _appliancesPageContoller =
        PageController(viewportFraction: 0.7, initialPage: 0);

    _appliancesPageContoller.addListener(() {
      _roomPageBloc.setPageOffSet(_appliancesPageContoller.page);
    });

    _getSharedPreferences();
  }

  Future _getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _reloadRoom() {
    _roomPageBloc.setLoadingStatus(true);
    _getRoom();
  }

  Future _getRoom() async {
    _roomModel = await _roomPageBloc.getRoom(widget.roomId);

    for (ApplianceModel appliance in _roomModel.applianceList) {
      print("Appliance :- ${appliance.applianceName}");
    }
    // print(_roomModel.id);
    Timer(
        Duration(
          seconds: 1,
        ), () {
      _roomPageBloc.setLoadingStatus(false);
    });
  }

  Widget _buildCustomAppBarHumidityWidget() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.lightBlue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/thermometer.png",
              color: Colors.white,
              height: 30.0,
              width: 30.0,
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "50",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Text(
              "Humidity",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildCustomAppBarTemperatureWidget() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 25.0,
          backgroundColor: Colors.lightBlue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/thermometer.png",
              color: Colors.white,
              height: 30.0,
              width: 30.0,
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "25",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            Text(
              "Temperature",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomAppBarWidget(double width, double height) {
    return PreferredSize(
      preferredSize: Size(width, height * 0.335),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.darkGrey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              45.0,
            ),
            bottomRight: Radius.circular(
              45.0,
            ),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 7.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 25.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 7.0,
                ),
                child: AvatarGlow(
                  startDelay: Duration(milliseconds: 0),
                  glowColor: Colors.white,
                  endRadius: 28.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 300),
                  child: IconButton(
                    icon: Hero(
                      tag: "$_roomTimelineHeroTag",
                      transitionOnUserGestures: true,
                      child: Icon(
                        Icons.timeline,
                        color: Colors.white,
                        size: 25.0,
                      ),
                    ),
                    onPressed: () {
                      Navigate.navigate(
                        context,
                        "/roomTimelinePage",
                        transactionType: TransactionType.fromRight,
                        arg: "$_roomTimelineHeroTag",
                      );
                    },
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 60.0, left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${_roomModel.roomName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "1 person has access",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildCustomAppBarTemperatureWidget(),
                    _buildCustomAppBarHumidityWidget(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildModeSwitchAddApplianceWidget() {
    return Stack(
      children: <Widget>[
        _roomModel.applianceList.isNotEmpty
            ? Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Auto Mode",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    XlivSwitch(
                      value: false,
                      activeColor: Colors.lightBlue,
                      unActiveColor: CustomColors.darkGrey,
                      onChanged: (bool value) {},
                    ),
                  ],
                ),
              )
            : Container(),
        _roomModel.applianceList.isNotEmpty
            ? Align(
                alignment: Alignment.centerRight,
                child: Hero(
                  transitionOnUserGestures: true,
                  tag: _roomModel.applianceList.isNotEmpty
                      ? "$_addButtonTag"
                      : "",
                  child: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    onPressed: () {
                      Navigate.navigate(
                        context,
                        '/addAppliancePage',
                        arg: <String, dynamic>{
                          "roomId": _roomModel.id,
                          "reloadRoom": _reloadRoom,
                        },
                        transactionType: TransactionType.fromRight,
                      );
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _buildApplianceSwitchWidget(int index) {
    return StreamBuilder<String>(
      stream: _roomPageBloc.getSwitchApplianceId,
      builder:
          (BuildContext context, AsyncSnapshot<String> applianceIdSnapshot) {
        return StreamBuilder<bool>(
          initialData: false,
          stream: _roomPageBloc.getSwitchStatus,
          builder: (BuildContext context, AsyncSnapshot<bool> statusSnapshot) {
            return XlivSwitch(
              value:
                  _roomModel.applianceList[index].id == applianceIdSnapshot.data
                      ? statusSnapshot.data
                      : _roomModel.applianceList[index].status,
              activeColor: Colors.lightBlue,
              unActiveColor: CustomColors.darkGrey,
              onChanged: (bool status) async {
                _roomPageBloc
                    .setSwitchApplianceId(_roomModel.applianceList[index].id);
                _roomPageBloc.setSwitchStatus(status);

                bool statusResponse = await NetworkCalls.changeApplianceStatus(
                  status,
                  _roomModel.applianceList[index].id,
                  widget.roomId,
                );

                _roomModel.applianceList[index].setStatus = statusResponse;
                _roomPageBloc.setSwitchStatus(statusResponse);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLowerCardWidget(int index) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Chip(
            backgroundColor: CustomColors.grey,
            label: Text(
              "${_roomModel.applianceList[index].applianceName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.settings),
            iconSize: 24.0,
            color: Colors.black,
            onPressed: () {
              Navigate.navigate(
                context,
                "/applianceSettingsPage",
                transactionType: TransactionType.fromRight,
                arg: <String, dynamic>{
                  "applianceId": _roomModel.applianceList[index].id,
                  "roomId": widget.roomId,
                  "userId": _prefs.getString("userId"),
                  "arduinoId": _roomModel.applianceList[index].arduinoId,
                  "pin": _roomModel.applianceList[index].pin,
                  "reloadRoom": _reloadRoom,
                },
              );
            },
          ),
        ),
        _roomModel.applianceList[index].applianceType == "READING"
            ? Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Chip(
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.all(5.0),
                    label: Text(
                      "16%",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            : Container(),
        _roomModel.applianceList[index].applianceType == "STATUS"
            ? Align(
                alignment: Alignment.bottomLeft,
                child: _buildApplianceSwitchWidget(index),
              )
            : Container(),
      ],
    );
  }

  Widget _buildPageViewCardWidget(int index, double height, String imagePath) {
    return StreamBuilder<double>(
      initialData: 0,
      stream: _roomPageBloc.getPageOffSet,
      builder:
          (BuildContext context, AsyncSnapshot<double> pageOffSetSnapshot) {
        return Card(
          margin: EdgeInsets.only(left: 12.0, right: 12.0, bottom: 24.0),
          elevation: 9,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              32.0,
            ),
          ),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                child: Container(
                  height: height * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("$imagePath"),
                      alignment: Alignment(
                          (-((pageOffSetSnapshot.data - index))).abs(), 0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: GestureDetector(
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: 8.0, right: 8.0, left: 8.0),
                    child: _buildLowerCardWidget(index),
                  ),
                  onTap: () {
                    print("Pressed GD");
                    if (_roomModel.applianceList.length == 1) {
                      Navigate.navigate(
                        context,
                        "/applianceSettingsPage",
                        transactionType: TransactionType.fromRight,
                        arg: <String, dynamic>{
                          "applianceId": _roomModel.applianceList[index].id,
                          "roomId": widget.roomId,
                          "userId": _prefs.getString("userId"),
                          "arduinoId":
                              _roomModel.applianceList[index].arduinoId,
                          "pin": _roomModel.applianceList[index].pin,
                           "reloadRoom": _reloadRoom,
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddApplianceButtonWidget() {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      borderSide: BorderSide(
        color: Colors.white,
        width: 0.5,
      ),
      icon: Hero(
        transitionOnUserGestures: true,
        tag: _roomModel.applianceList.isEmpty ? "$_addButtonTag" : "",
        child: Icon(
          Icons.add_circle,
          color: Colors.white,
        ),
      ),
      label: Text(
        "Add appliance",
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      highlightColor: Colors.white30,
      highlightedBorderColor: Colors.lightBlue,
      splashColor: Colors.lightBlue,
      padding: EdgeInsets.all(12.0),
      onPressed: () {
        Navigate.navigate(
          context,
          '/addAppliancePage',
          arg: <String, dynamic>{
            "roomId": _roomModel.id,
            "reloadRoom": _reloadRoom,
          },
          transactionType: TransactionType.fromRight,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);

    return Container(
      height: height,
      width: width,
      color: CustomColors.grey,
      child: StreamBuilder<bool>(
        initialData: true,
        stream: _roomPageBloc.getLoadingStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
          return !loadingSnapshot.data
              ? Scaffold(
                  backgroundColor: CustomColors.grey,
                  appBar: _buildCustomAppBarWidget(width, height),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
                        child: _buildModeSwitchAddApplianceWidget(),
                      ),
                      SizedBox(
                        height: height * 0.55,
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: _roomModel.applianceList.isNotEmpty
                              ? StreamBuilder<double>(
                                  initialData: 0,
                                  stream: _roomPageBloc.getPageOffSet,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<double>
                                          pageOffSetSnapshot) {
                                    return PageView.builder(
                                      itemCount:
                                          _roomModel.applianceList.length,
                                      controller: _appliancesPageContoller,
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String imagePath;

                                        if (index == 0 || index % 3 == 0) {
                                          imagePath = "assets/colorful_bg1.png";
                                        }

                                        if (index == 1 ||
                                            (index - 1) % 3 == 0) {
                                          imagePath = "assets/colorful_bg2.jpg";
                                        }

                                        if (index == 2 ||
                                            (index - 2) % 3 == 0) {
                                          imagePath = "assets/colorful_bg3.png";
                                        }

                                        return _buildPageViewCardWidget(
                                          index,
                                          height,
                                          imagePath,
                                        );
                                      },
                                    );
                                  },
                                )
                              : Center(
                                  child: _buildAddApplianceButtonWidget(),
                                ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2.0,
                    backgroundColor: Colors.transparent,
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    StatusNavBarColorChanger.changeNavBarColor(CustomColors.darkGrey);
    super.dispose();
  }
}
