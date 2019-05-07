import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/monitor_page_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/blocs/home_page_bloc.dart';
import 'package:flutter_home_automation/blocs/rooms_page_bloc.dart';
import 'package:flutter_home_automation/pages/home_bottom_nav_pages/about_us_page.dart';
import 'package:flutter_home_automation/pages/home_bottom_nav_pages/rooms_page.dart';
import 'package:flutter_home_automation/pages/home_bottom_nav_pages/monitor_page.dart';
import 'package:flutter_home_automation/pages/home_bottom_nav_pages/timeline_page.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final GlobalKey<ScaffoldState> _sfKey = GlobalKey<ScaffoldState>();
  double height,width;

  List<Widget> _pages;
  HomePageBloc _homePageBloc;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      // SocketIOCalls.getSocketIO(
      //   id: prefs.getString("userId"),
      // );
    });

    _homePageBloc = BlocProvider.of<HomePageBloc>(context);

    _pages = List<Widget>();
    _pages.addAll(
      <Widget>[
        BlocProvider(
          bloc: HomePageBloc(),
          child: BlocProvider(
            bloc: MonitorPageBloc(),
            child: MonitorPage(),
          ),
        ),
        BlocProvider(
          bloc: RoomsPageBloc(),
          child: RoomsPage(),
        ),
        TimelinePage(),
        AboutUsPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
     height = MediaQuery.of(context).size.height;
     width = MediaQuery.of(context).size.width;

    // print("14 is the ${(14 * 100) / height}% of Height :- $height");

    StatusNavBarColorChanger.changeNavBarColor(
      CustomColors.darkGrey,
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _sfKey,
      backgroundColor: CustomColors.darkPurple,
      body: StreamBuilder<int>(
        initialData: 0,
        stream: _homePageBloc.getDrawerPageIndex,
        builder:
            (BuildContext context, AsyncSnapshot<int> drawerPageIndexSnapshot) {
          return _pages[drawerPageIndexSnapshot.data];
        },
      ),
      bottomNavigationBar: Container(
        child: BottomNavyBar(
          backgroundColor: CustomColors.darkGrey,
          onItemSelected: (index) => _homePageBloc.setDrawerPageIndex(index),
          items: [
            BottomNavyBarItem(
              inactiveColor: Colors.white,
              icon: Icon(Icons.remove_red_eye),
              title: Text('Monitor'),
              activeColor: Colors.amber,
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.white,
              icon: Icon(Icons.people),
              title: Text('Rooms'),
              activeColor: Colors.lightBlue,
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.white,
              icon: Icon(Icons.timeline),
              title: Text('Analysis'),
              activeColor: Colors.green,
            ),
            BottomNavyBarItem(
              inactiveColor: Colors.white,
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: Colors.lime,
            ),
          ],
        ),
      ),
    );
  }
}
