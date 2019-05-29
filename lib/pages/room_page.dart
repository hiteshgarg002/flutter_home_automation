import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/blocs/room_page_bloc.dart';
import 'package:flutter_home_automation/models/appliance_model.dart';
import 'package:flutter_home_automation/models/room_model.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:flutter_home_automation/utils/native_calls.dart';
import 'package:navigate/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlive_switch/xlive_switch.dart';

class RoomPage extends StatefulWidget {
  final String roomId;
  final Function reloadRooms;

  RoomPage({
    @required this.roomId,
    @required this.reloadRooms,
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
  double height, width;
  List<String> _appliancesNamesTemporary = [
    "Bulb 1",
    "Bulb 2",
    "Bulb 3",
    "Bulb 4",
    "Bulb 5",
    "Bulb 6",
  ];
  bool b1 = false, b2 = false, b3 = false, b4 = false, b5 = false, b6 = false;
  bool autoMode = false;

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
    _getAutoModeStatus();
    _getBulbButtonStatus();
  }

  Future _getAutoModeStatus() async {
    Map res = await NetworkCalls.getTempAutoModeStatus();

    if (res.containsKey("status")) {
      autoMode = res["status"] as bool;
    } else {
      autoMode = false;
    }

    setState(() {});
  }

  Future _getBulbButtonStatus() async {
    Map res = await NetworkCalls.getTempBulbButtonStatus();

    if (res.length == 0) {
      b1 = false;
      b2 = false;
      b3 = false;
      b4 = false;
      b5 = false;
      b6 = false;

      setState(() {});
    } else {
      if (res.containsKey("1")) {
        b1 = res["1"];
      }
      if (res.containsKey("2")) {
        b2 = res["2"];
      }
      if (res.containsKey("3")) {
        b3 = res["3"];
      }
      if (res.containsKey("4")) {
        b4 = res["4"];
      }
      if (res.containsKey("5")) {
        b5 = res["5"];
      }
      if (res.containsKey("6")) {
        b6 = res["6"];
      }

      setState(() {});
    }
  }

  Future _getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _reloadRoom() {
    _roomPageBloc.setLoadingStatus(true);
    widget.reloadRooms();
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
          radius: ((3.386 * height) / 100),
          backgroundColor: Colors.lightBlue,
          child: Padding(
            padding: EdgeInsets.all(((1.083 * height) / 100)),
            child: Image.asset(
              "assets/thermometer.png",
              color: Colors.white,
              height: ((4.064 * height) / 100),
              width: ((4.064 * height) / 100),
            ),
          ),
        ),
        SizedBox(
          width: ((0.677 * height) / 100),
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
                    fontSize: ((2.980 * height) / 100),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "%",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ((2.438 * height) / 100),
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
          radius: ((3.386 * height) / 100),
          backgroundColor: Colors.lightBlue,
          child: Padding(
            padding: EdgeInsets.all(((1.083 * height) / 100)),
            child: Image.asset(
              "assets/thermometer.png",
              color: Colors.white,
              height: ((4.064 * height) / 100),
              width: ((4.064 * height) / 100),
            ),
          ),
        ),
        SizedBox(
          width: ((0.677 * height) / 100),
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
                    fontSize: ((2.980 * height) / 100),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "°C",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ((2.438 * height) / 100),
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

  Widget _buildCustomAppBarWidget() {
    return PreferredSize(
      preferredSize: Size(width, height * 0.335),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.darkGrey,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
              ((6.096 * height) / 100),
            ),
            bottomRight: Radius.circular(
              ((6.096 * height) / 100),
            ),
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: ((0.948 * height) / 100),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: ((3.386 * height) / 100),
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
                  right: ((0.948 * height) / 100),
                ),
                child: AvatarGlow(
                  startDelay: Duration(milliseconds: 0),
                  glowColor: Colors.white,
                  endRadius: ((3.793 * height) / 100),
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
                        size: ((3.386 * height) / 100),
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
                padding: EdgeInsets.only(
                  top: ((8.128 * height) / 100),
                  left: ((3.386 * height) / 100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${_roomModel.roomName}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ((4.064 * height) / 100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ((0.677 * height) / 100),
                    ),
                    Text(
                      "1 person has access",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ((1.896 * height) / 100),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: ((5.418 * height) / 100)),
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

  // Widget _buildModeSwitchAddApplianceWidget() {
  //   return Stack(
  //     children: <Widget>[
  //       _roomModel.applianceList.isNotEmpty
  //           ? Align(
  //               alignment: Alignment.centerLeft,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: <Widget>[
  //                   Text(
  //                     "Auto Mode",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: ((1.896 * height) / 100),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: 5.0,
  //                   ),
  //                   XlivSwitch(
  //                     value: false,
  //                     activeColor: Colors.lightBlue,
  //                     unActiveColor: Colors.white,
  //                     thumbColor: Colors.black45,
  //                     onChanged: (bool value) {},
  //                   ),
  //                 ],
  //               ),
  //             )
  //           : Container(),
  //       _roomModel.applianceList.isNotEmpty
  //           ? Align(
  //               alignment: Alignment.centerRight,
  //               child: Hero(
  //                 transitionOnUserGestures: true,
  //                 tag: _roomModel.applianceList.isNotEmpty
  //                     ? "$_addButtonTag"
  //                     : "",
  //                 child: IconButton(
  //                   icon: Icon(
  //                     Icons.add_circle,
  //                     color: Colors.white,
  //                     size: ((3.386 * height) / 100),
  //                   ),
  //                   onPressed: () {
  //                     Navigate.navigate(
  //                       context,
  //                       '/addAppliancePage',
  //                       arg: <String, dynamic>{
  //                         "roomId": _roomModel.id,
  //                         "reloadRoom": _reloadRoom,
  //                       },
  //                       transactionType: TransactionType.fromRight,
  //                     );
  //                   },
  //                 ),
  //               ),
  //             )
  //           : Container(),
  //     ],
  //   );
  // }

  Widget _buildModeSwitchAddApplianceTemporaryWidget() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Auto Mode",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ((1.896 * height) / 100),
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              XlivSwitch(
                value: autoMode,
                activeColor: Colors.lightBlue,
                unActiveColor: Colors.white,
                thumbColor: Colors.black45,
                onChanged: (bool value) async {
                  autoMode = value;
                  setState(() {});

                  bool status = await NetworkCalls.setTempAutoModeStatus(value);
                  print("Automode status :- $status");
                  autoMode = status;
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: ((3.386 * height) / 100),
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
      ],
    );
  }

  // Widget _buildApplianceSwitchWidget(int index) {
  //   return StreamBuilder<String>(
  //     stream: _roomPageBloc.getSwitchApplianceId,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<String> applianceIdSnapshot) {
  //       return StreamBuilder<bool>(
  //         initialData: false,
  //         stream: _roomPageBloc.getSwitchStatus,
  //         builder: (BuildContext context, AsyncSnapshot<bool> statusSnapshot) {
  //           return XlivSwitch(
  //             value:
  //                 _roomModel.applianceList[index].id == applianceIdSnapshot.data
  //                     ? statusSnapshot.data
  //                     : _roomModel.applianceList[index].status,
  //             activeColor: Colors.lightBlue,
  //             unActiveColor: CustomColors.darkGrey,
  //             onChanged: (bool status) async {
  //               _roomPageBloc
  //                   .setSwitchApplianceId(_roomModel.applianceList[index].id);
  //               _roomPageBloc.setSwitchStatus(status);

  //               bool statusResponse = await NetworkCalls.changeApplianceStatus(
  //                 status,
  //                 _roomModel.applianceList[index].id,
  //                 widget.roomId,
  //               );

  //               _roomModel.applianceList[index].setStatus = statusResponse;
  //               _roomPageBloc.setSwitchStatus(statusResponse);
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  Widget _buildApplianceSwitchTemporaryWidget1(int index) {
    return XlivSwitch(
      activeColor: Colors.lightBlue,
      unActiveColor: CustomColors.darkGrey,
      onChanged: (bool value) async {
        b1 = value;
        setState(() {});

        bool status =
            await NetworkCalls.setTempBulbButtonStatus(index + 1, value);
        b1 = status;
        setState(() {});
      },
      value: b1,
    );
  }

  Widget _buildApplianceSwitchTemporaryWidget2(int index) {
    return XlivSwitch(
      activeColor: Colors.lightBlue,
      unActiveColor: CustomColors.darkGrey,
      onChanged: (bool value) async {
        b2 = value;
        setState(() {});

        bool status =
            await NetworkCalls.setTempBulbButtonStatus(index + 1, value);
        b2 = status;
        setState(() {});
      },
      value: b2,
    );
  }

  Widget _buildApplianceSwitchTemporaryWidget3(int index) {
    return XlivSwitch(
      activeColor: Colors.lightBlue,
      unActiveColor: CustomColors.darkGrey,
      onChanged: (bool value) async {
        b3 = value;
        setState(() {});

        bool status =
            await NetworkCalls.setTempBulbButtonStatus(index + 1, value);
        b3 = status;
        setState(() {});
      },
      value: b3,
    );
  }

  Widget _buildApplianceSwitchTemporaryWidget4(int index) {
    return XlivSwitch(
      activeColor: Colors.lightBlue,
      unActiveColor: CustomColors.darkGrey,
      onChanged: (bool value) async {
        b4 = value;
        setState(() {});

        bool status =
            await NetworkCalls.setTempBulbButtonStatus(index + 1, value);
        b4 = status;
        setState(() {});
      },
      value: b4,
    );
  }

  Widget _buildApplianceSwitchTemporaryWidget5(int index) {
    return XlivSwitch(
      activeColor: Colors.lightBlue,
      unActiveColor: CustomColors.darkGrey,
      onChanged: (bool value) async {
        b5 = value;
        setState(() {});

        bool status =
            await NetworkCalls.setTempBulbButtonStatus(index + 1, value);
        b5 = status;
        setState(() {});
      },
      value: b5,
    );
  }

  Widget _buildApplianceSwitchTemporaryWidget6(int index) {
    return XlivSwitch(
      activeColor: Colors.lightBlue,
      unActiveColor: CustomColors.darkGrey,
      onChanged: (bool value) async {
        b6 = value;
        setState(() {});

        bool status =
            await NetworkCalls.setTempBulbButtonStatus(index + 1, value);
        b6 = status;
        setState(() {});
      },
      value: b6,
    );
  }

  // Widget _buildLowerCardWidget(int index) {
  //   return Stack(
  //     children: <Widget>[
  //       Align(
  //         alignment: Alignment.topCenter,
  //         child: Chip(
  //           backgroundColor: CustomColors.grey,
  //           label: Text(
  //             "${_roomModel.applianceList[index].applianceName}",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: ((2.167 * height) / 100),
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //       Align(
  //         alignment: Alignment.bottomRight,
  //         child: IconButton(
  //           icon: Icon(Icons.settings),
  //           iconSize: ((3.251 * height) / 100),
  //           color: Colors.black,
  //           onPressed: () {
  //             Navigate.navigate(
  //               context,
  //               "/applianceSettingsPage",
  //               transactionType: TransactionType.fromRight,
  //               arg: <String, dynamic>{
  //                 "applianceId": _roomModel.applianceList[index].id,
  //                 "roomId": widget.roomId,
  //                 "userId": _prefs.getString("userId"),
  //                 "arduinoId": _roomModel.applianceList[index].arduinoId,
  //                 "pin": _roomModel.applianceList[index].pin,
  //                 "reloadRoom": _reloadRoom,
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //       _roomModel.applianceList[index].applianceType == "READING"
  //           ? Align(
  //               alignment: Alignment.center,
  //               child: Padding(
  //                 padding: EdgeInsets.only(top: ((0.677 * height) / 100)),
  //                 child: Chip(
  //                   backgroundColor: Colors.amber,
  //                   padding: EdgeInsets.all(((0.677 * height) / 100)),
  //                   label: Text(
  //                     "16%",
  //                     style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: ((2.709 * height) / 100),
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           : Container(),
  //       _roomModel.applianceList[index].applianceType == "STATUS"
  //           ? Align(
  //               alignment: Alignment.bottomLeft,
  //               child: _buildApplianceSwitchWidget(index),
  //             )
  //           : Container(),
  //     ],
  //   );
  // }

  Widget _buildLowerCardWidgetTemporary(int index) {
    Function switchButton;
    if (index == 0) {
      switchButton = _buildApplianceSwitchTemporaryWidget1;
    } else if (index == 1) {
      switchButton = _buildApplianceSwitchTemporaryWidget2;
    } else if (index == 2) {
      switchButton = _buildApplianceSwitchTemporaryWidget3;
    } else if (index == 3) {
      switchButton = _buildApplianceSwitchTemporaryWidget4;
    } else if (index == 4) {
      switchButton = _buildApplianceSwitchTemporaryWidget5;
    } else if (index == 5) {
      switchButton = _buildApplianceSwitchTemporaryWidget6;
    }

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Chip(
            backgroundColor: CustomColors.grey,
            label: Text(
              "${_appliancesNamesTemporary[index]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((2.167 * height) / 100),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.settings),
            iconSize: ((3.251 * height) / 100),
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
        Align(
          alignment: Alignment.bottomLeft,
          child: switchButton(index),
        ),
      ],
    );
  }

  // Widget _buildPageViewCardWidget(int index, String imagePath) {
  //   return StreamBuilder<double>(
  //     initialData: 0,
  //     stream: _roomPageBloc.getPageOffSet,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<double> pageOffSetSnapshot) {
  //       return Card(
  //         margin: EdgeInsets.only(
  //             left: ((1.625 * height) / 100),
  //             right: ((1.625 * height) / 100),
  //             bottom: ((3.251 * height) / 100)),
  //         elevation: ((1.219 * height) / 100),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(
  //             ((4.334 * height) / 100),
  //           ),
  //         ),
  //         child: Column(
  //           children: <Widget>[
  //             ClipRRect(
  //               borderRadius: BorderRadius.vertical(
  //                   top: Radius.circular(((4.334 * height) / 100))),
  //               child: Container(
  //                 height: height * 0.28,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   image: DecorationImage(
  //                     fit: BoxFit.cover,
  //                     image: AssetImage("$imagePath"),
  //                     alignment: Alignment(
  //                         (-((pageOffSetSnapshot.data - index))).abs(), 0),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: ((1.083 * height) / 100)),
  //             Expanded(
  //               child: GestureDetector(
  //                 child: Padding(
  //                   padding: EdgeInsets.only(
  //                       bottom: ((1.083 * height) / 100),
  //                       right: ((1.083 * height) / 100),
  //                       left: ((1.083 * height) / 100)),
  //                   child: _buildLowerCardWidget(index),
  //                 ),
  //                 onTap: () {
  //                   if (_roomModel.applianceList.length == 1) {
  //                     Navigate.navigate(
  //                       context,
  //                       "/applianceSettingsPage",
  //                       transactionType: TransactionType.fromRight,
  //                       arg: <String, dynamic>{
  //                         "applianceId": _roomModel.applianceList[index].id,
  //                         "roomId": widget.roomId,
  //                         "userId": _prefs.getString("userId"),
  //                         "arduinoId":
  //                             _roomModel.applianceList[index].arduinoId,
  //                         "pin": _roomModel.applianceList[index].pin,
  //                         "reloadRoom": _reloadRoom,
  //                       },
  //                     );
  //                   }
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildPageViewCardTemporaryWidget(int index) {
    return StreamBuilder<double>(
      initialData: 0,
      stream: _roomPageBloc.getPageOffSet,
      builder:
          (BuildContext context, AsyncSnapshot<double> pageOffSetSnapshot) {
        return Card(
          margin: EdgeInsets.only(
              left: ((1.625 * height) / 100),
              right: ((1.625 * height) / 100),
              bottom: ((3.251 * height) / 100)),
          elevation: ((1.219 * height) / 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ((4.334 * height) / 100),
            ),
          ),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(((4.334 * height) / 100))),
                child: Container(
                  height: height * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      // fit: BoxFit.cover,

                      image: AssetImage(
                        "assets/bulb_gif.gif",
                      ),
                      alignment: Alignment(
                          (-((pageOffSetSnapshot.data - index))).abs(), 0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ((1.083 * height) / 100)),
              Expanded(
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: ((1.083 * height) / 100),
                        right: ((1.083 * height) / 100),
                        left: ((1.083 * height) / 100)),
                    child: _buildLowerCardWidgetTemporary(index),
                  ),
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
        borderRadius: BorderRadius.circular(((2.032 * height) / 100)),
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
          fontSize: ((1.896 * height) / 100),
        ),
      ),
      highlightColor: Colors.white30,
      highlightedBorderColor: Colors.lightBlue,
      splashColor: Colors.lightBlue,
      padding: EdgeInsets.all(((1.625 * height) / 100)),
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);

    // return Container(
    //   height: height,
    //   width: width,
    //   color: CustomColors.grey,
    //   child: StreamBuilder<bool>(
    //     initialData: true,
    //     stream: _roomPageBloc.getLoadingStatus,
    //     builder: (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
    //       return !loadingSnapshot.data
    //           ? Scaffold(
    //               backgroundColor: CustomColors.grey,
    //               appBar: _buildCustomAppBarWidget(),
    //               body: Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 mainAxisSize: MainAxisSize.max,
    //                 children: <Widget>[
    //                   Padding(
    //                     padding: EdgeInsets.only(
    //                         top: ((1.354 * height) / 100),
    //                         right: ((2.709 * height) / 100),
    //                         left: ((2.709 * height) / 100)),
    //                     child: _buildModeSwitchAddApplianceWidget(),
    //                   ),
    //                   SizedBox(
    //                     height: height * 0.55,
    //                     child: Padding(
    //                       padding:
    //                           EdgeInsets.only(top: ((4.064 * height) / 100)),
    //                       child: _roomModel.applianceList.isNotEmpty
    //                           ? StreamBuilder<double>(
    //                               initialData: 0,
    //                               stream: _roomPageBloc.getPageOffSet,
    //                               builder: (BuildContext context,
    //                                   AsyncSnapshot<double>
    //                                       pageOffSetSnapshot) {
    //                                 return PageView.builder(
    //                                   itemCount:
    //                                       _roomModel.applianceList.length,
    //                                   controller: _appliancesPageContoller,
    //                                   scrollDirection: Axis.horizontal,
    //                                   physics: BouncingScrollPhysics(),
    //                                   itemBuilder:
    //                                       (BuildContext context, int index) {
    //                                     String imagePath;

    //                                     if (index == 0 || index % 3 == 0) {
    //                                       imagePath = "assets/colorful_bg1.png";
    //                                     }

    //                                     if (index == 1 ||
    //                                         (index - 1) % 3 == 0) {
    //                                       imagePath = "assets/colorful_bg2.jpg";
    //                                     }

    //                                     if (index == 2 ||
    //                                         (index - 2) % 3 == 0) {
    //                                       imagePath = "assets/colorful_bg3.png";
    //                                     }

    //                                     return _buildPageViewCardWidget(
    //                                       index,
    //                                       imagePath,
    //                                     );
    //                                   },
    //                                 );
    //                               },
    //                             )
    //                           : Center(
    //                               child: _buildAddApplianceButtonWidget(),
    //                             ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           : Center(
    //               child: CircularProgressIndicator(
    //                 valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    //                 strokeWidth: 2.0,
    //                 backgroundColor: Colors.transparent,
    //               ),
    //             );
    //     },
    //   ),
    // );

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
                  appBar: _buildCustomAppBarWidget(),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: ((1.354 * height) / 100),
                            right: ((2.709 * height) / 100),
                            left: ((2.709 * height) / 100)),
                        child: _buildModeSwitchAddApplianceTemporaryWidget(),
                      ),
                      SizedBox(
                        height: height * 0.55,
                        child: Padding(
                            padding:
                                EdgeInsets.only(top: ((4.064 * height) / 100)),
                            child: StreamBuilder<double>(
                              initialData: 0,
                              stream: _roomPageBloc.getPageOffSet,
                              builder: (BuildContext context,
                                  AsyncSnapshot<double> pageOffSetSnapshot) {
                                return PageView.builder(
                                  itemCount: 6,
                                  controller: _appliancesPageContoller,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String imagePath;

                                    // if (index == 0 || index % 3 == 0) {
                                    //   imagePath = "assets/colorful_bg1.png";
                                    // }

                                    // if (index == 1 || (index - 1) % 3 == 0) {
                                    //   imagePath = "assets/colorful_bg2.jpg";
                                    // }

                                    // if (index == 2 || (index - 2) % 3 == 0) {
                                    //   imagePath = "assets/colorful_bg3.png";
                                    // }

                                    return _buildPageViewCardTemporaryWidget(
                                        index);
                                  },
                                );
                              },
                            )),
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
