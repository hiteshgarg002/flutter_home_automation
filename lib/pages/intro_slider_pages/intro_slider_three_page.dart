import 'package:flutter/material.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:pigment/pigment.dart';

class IntroSliderThreePage extends StatefulWidget {
  @override
  _IntroSliderOnePageState createState() => _IntroSliderOnePageState();
}

class _IntroSliderOnePageState extends State<IntroSliderThreePage> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: CustomColors.darkGrey,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage("assets/slider_security.png"),
              width: width * 0.60,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Intro Test",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "This is the into test for the slider screen one built for the home automation app that controls the appliances.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
