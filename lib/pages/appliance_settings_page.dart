import 'package:flutter/material.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';

class ApplianceSettingsPage extends StatefulWidget {
  final Map applianceData;

  ApplianceSettingsPage({@required this.applianceData});
  @override
  _ApplianceSettingsPageState createState() => _ApplianceSettingsPageState();
}

class _ApplianceSettingsPageState extends State<ApplianceSettingsPage> {
  double height, width;
  Widget _buildCustomAppBarWidget() {
    return PreferredSize(
      preferredSize: Size(width, height * 0.25),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: ((1.083 * height) / 100)),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: ((3.386 * height) / 100),
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
              padding: EdgeInsets.only(right: ((1.083 * height) / 100)),
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(((2.032 * height) / 100)),
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: ((1.896 * height) / 100),
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
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  top: ((8.128 * height) / 100),
                  left: ((3.386 * height) / 100)),
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
                    width: ((0.677 * height) / 100),
                  ),
                  Chip(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.all(6.0),
                    label: Text("Lamp"),
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ((1.896 * height) / 100),
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(Colors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildCustomAppBarWidget(),
    );
  }

  @override
  void dispose() {
    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);
    super.dispose();
  }
}
