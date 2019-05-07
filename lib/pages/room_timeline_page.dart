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
          //     ((6.096 * height) / 100),
          //   ),
          //   bottomRight: Radius.circular(
          //     ((6.096 * height) / 100),
          //   ),
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: ((0.948 * height) / 100),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: ((3.386 * height) / 100),
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
                left: ((3.386 * height) / 100),
                right: ((2.709 * height) / 100),
              ),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Timeline",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ((4.064 * height) / 100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: ((5.418 * height) / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          ((2.709 * height) / 100),
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
            SizedBox(height: ((2.709 * height) / 100)),
            Expanded(
              child: Center(
                child: TabBar(
                  indicatorColor: Colors.white, indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  labelPadding: EdgeInsets.only(
                    bottom: ((1.354 * height) / 100),
                    left: ((1.625 * height) / 100),
                    right: ((1.625 * height) / 100),
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
                            fontSize: ((1.896 * height) / 100),
                            letterSpacing: ((0.203 * height) / 100),
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
