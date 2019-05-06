import 'package:flutter/material.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:xlive_switch/xlive_switch.dart';

class ApplianceSettingsPage extends StatefulWidget {
  final Map applianceData;

  ApplianceSettingsPage({@required this.applianceData});
  @override
  _ApplianceSettingsPageState createState() => _ApplianceSettingsPageState();
}

class _ApplianceSettingsPageState extends State<ApplianceSettingsPage> {
  Widget _buildCustomAppBarWidget(double height, double width) {
    return PreferredSize(
      preferredSize: Size(width, height * 0.25),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 25.0,
                ),
                onPressed: () {
                  StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
                highlightColor: Colors.white54,
                highlightedBorderColor: Colors.lightBlue,
                splashColor: Colors.lightBlue,
                padding: EdgeInsets.all(6.0),
                onPressed: () async {
                  await NetworkCalls.deteleAppliance(widget.applianceData);
                  (widget.applianceData["reloadRoom"])();
                  Navigator.pop(context);
                },
              ),
              // child: IconButton(
              //   tooltip: "Delete Room",
              //   icon: Icon(
              //     Icons.delete_sweep,
              //     color: Colors.black,
              //     size: 27.0,
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //     NetworkCalls.deteleAppliance(widget.applianceData);
              //   },
              // ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 60.0, left: 25.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Chip(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.all(6.0),
                    label: Text("Lamp"),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(Colors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBarWidget(width, height),
    );
  }

  @override
  void dispose() {
    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);
    super.dispose();
  }
}
