import 'package:flutter/material.dart';
import 'package:flutter_home_automation/pages/intro_slider_pages/intro_slider_one_page.dart';
import 'package:flutter_home_automation/pages/intro_slider_pages/intro_slider_three_page.dart';
import 'package:flutter_home_automation/pages/intro_slider_pages/intro_slider_two_page.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:flutter_home_automation/widgets/login_signup_bottom_custom_painer_widget.dart';
import 'package:navigate/navigate.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSliderPage extends StatefulWidget {
  @override
  _IntroSliderPageState createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage>
    with SingleTickerProviderStateMixin {
  PageController _introSliderController;
  SharedPreferences _sharedPreferences;

  @override
  void initState() {
    _introSliderController = PageController(
      initialPage: 0,
      keepPage: true,
    );

    _setupSharedPreferences();

    super.initState();
  }

  Future _setupSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    StatusNavBarColorChanger.changeNavBarColor(CustomColors.grey);

    return Scaffold(
      backgroundColor: CustomColors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowGlow();
              },
              child: PageView(
                controller: _introSliderController,
                scrollDirection: Axis.horizontal,
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  IntroSliderOnePage(),
                  IntroSliderTwoPage(),
                  IntroSliderThreePage(),
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              CustomPaint(
                painter: LoginSignupBottomCustomPainter(),
                child: Container(
                  width: width,
                  height: height * 0.20,
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: height * 0.05,
                    ),
                    child: GestureDetector(
                      child: Text(
                        "Login To Your Account!",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                        ),
                      ),
                      onTap: () {
                        _sharedPreferences.setBool("intro_done", true);
                        Navigate.navigate(
                          context,
                          "/loginPage",
                          transactionType: TransactionType.fromBottom,
                          replaceRoute: ReplaceRoute.all,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: PageIndicator(
                    layout: PageIndicatorLayout.DROP,
                    size: 10.0,
                    controller: _introSliderController,
                    space: 5.0,
                    count: 3,
                    activeColor: Colors.white,
                    // color: Colors.white.withAlpha(90),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
