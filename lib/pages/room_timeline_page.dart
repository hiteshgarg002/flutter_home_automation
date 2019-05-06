import 'package:flutter/material.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:avatar_glow/avatar_glow.dart';

class RoomTimelinePage extends StatefulWidget {
  final String roomTimelineHeroTag;

  RoomTimelinePage({@required this.roomTimelineHeroTag});
  @override
  _RoomTimelinePageState createState() => _RoomTimelinePageState();
}

class _RoomTimelinePageState extends State<RoomTimelinePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

// dynamic tabs list
  List<String> tabs = [
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
    "Lamp1",
  ];

  @override
  void initState() {
    super.initState();
    // here the no. of tabs will be equal to no. of appiances in a room, that we will fetch from the database.
    _tabController =
        TabController(vsync: this, length: tabs.length, initialIndex: 0);
  }

  Widget _buildCustomAppBarWidget(double width, double height) {
    return PreferredSize(
      preferredSize: Size(width, height * 0.24),
      child: Container(
        decoration: BoxDecoration(
          color: CustomColors.darkGrey,
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(
          //     45.0,
          //   ),
          //   bottomRight: Radius.circular(
          //     45.0,
          //   ),
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 7.0,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 25.0,
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 12.5,
                left: 25.0,
                right: 20.0,
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Timeline",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      child: AvatarGlow(
                        startDelay: Duration(milliseconds: 0),
                        glowColor: Colors.white,
                        endRadius: 28.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 300),
                        child: Hero(
                          tag: "${widget.roomTimelineHeroTag}",
                          transitionOnUserGestures: true,
                          child: Icon(
                            Icons.timeline,
                            size: 33.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Center(
                child: TabBar(
                  indicatorColor: Colors.white, indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  labelPadding: EdgeInsets.only(
                    bottom: 10.0,
                    left: 12.0,
                    right: 12.0,
                  ),
                  controller: _tabController,
                  isScrollable: true,
                  // dynamic tabs
                  tabs: List<Widget>.generate(
                    tabs.length,
                    (int index) {
                      return Tab(
                        child: Text(
                          "${tabs[index]}",
                          style: TextStyle(
                            fontSize: 14.0,
                            letterSpacing: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildCustomAppBarWidget(width, height),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
