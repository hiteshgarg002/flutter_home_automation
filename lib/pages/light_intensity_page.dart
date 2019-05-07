import 'package:fcharts/fcharts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:pigment/pigment.dart';

class LightIntensityPage extends StatefulWidget {
  @override
  _LightIntensityPageState createState() => _LightIntensityPageState();
}

class _LightIntensityPageState extends State<LightIntensityPage> {
  static final GlobalKey<AnimatedCircularChartState> _chartKey1 =
      GlobalKey<AnimatedCircularChartState>();
      double height, width;

  final String _lightIntensityHeroTag = "LIGHT_INTENSITY";

  static const myData = [
    ["Sun", "10"],
    ["Mon", "55"],
    ["Tue", "30"],
    ["Wed", "55"],
    ["Thu", "20"],
    ["Fri", "80"],
    ["Sat", "30"],
  ];

  static double _percentage = 78.0;
  static double _completePercentage = 100.0;

  List<CircularStackEntry> data = <CircularStackEntry>[
    CircularStackEntry(
      <CircularSegmentEntry>[
        CircularSegmentEntry(
          _percentage,
          Colors.lightBlue,
          rankKey: 'Q1',
        ),
        CircularSegmentEntry(
          _completePercentage - _percentage,
          CustomColors.grey,
          rankKey: 'Q2',
        ),
      ],
      rankKey: 'LightIntensity',
    ),
  ];

  @override
  Widget build(BuildContext context) {
     height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;

    StatusNavBarColorChanger.changeNavBarColor(
      CustomColors.darkGrey,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.07),
        child: Container(
          color: CustomColors.darkestGrey,
          child: Stack(
            children: <Widget>[
              AppBar(
                leading: Container(),
                elevation: 1.0,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      splashColor: CustomColors.darkGrey,
                      highlightColor: CustomColors.darkGrey,
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      "Light Intensity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ((2.032 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: CustomColors.darkGrey,
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(((2.709 * height) / 100)),
            child: Chip(
              backgroundColor: Colors.white,
              elevation: ((0.677 * height) / 100),
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              label: Text(
                "Home",
                style: TextStyle(
                  fontSize: ((2.032 * height) / 100),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              height: 300.0,
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  AnimatedCircularChart(
                    edgeStyle: SegmentEdgeStyle.round,
                    key: _chartKey1,
                    size: Size(
                      250.0,
                      250.0,
                    ),
                    duration: Duration(
                      milliseconds: 1500,
                    ),
                    percentageValues: false,
                    holeLabel: "$_percentage%",
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: ((2.438 * height) / 100),
                    ),
                    initialChartData: data,
                    holeRadius: 70.0,
                    chartType: CircularChartType.Radial,
                  ),
                  LineChart(
                    lines: [
                      Line<List<String>, String, String>(
                        data: myData,
                        xFn: (datum) => datum[0],
                        yFn: (datum) => datum[1],
                        stroke: PaintOptions.stroke(
                          color: Colors.green,
                          strokeCap: StrokeCap.round,
                          strokeWidth: ((0.203 * height) / 100),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment(
                              0.8,
                              0.0,
                            ), // 10% of the width, so there are ten blinds.
                            colors: [
                              Colors.lightBlue,
                              Colors.green,
                            ], // whitish to gray
                            tileMode: TileMode
                                .clamp, // repeats the gradient over the canvas
                          ),
                        ),
                        marker: MarkerOptions(
                          paint: PaintOptions.stroke(
                            color: Colors.white,
                            strokeCap: StrokeCap.round,
                          ),
                          shape: MarkerShapes.circle,
                          size: ((0.677 * height) / 100),
                        ),
                        curve: CardinalSpline(),
                        yAxis: ChartAxis(
                          opposite: false,
                          paint: PaintOptions.stroke(
                            color: Colors.amber,
                          ),
                          tickLabelerStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        xAxis: ChartAxis(
                          opposite: false,
                          paint: PaintOptions.stroke(
                            color: Colors.lime,
                          ),
                          tickLabelerStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    chartPadding: EdgeInsets.fromLTRB(
                      ((5.418 * height) / 100),
                      ((2.709 * height) / 100),
                      ((2.709 * height) / 100),
                      ((2.709 * height) / 100),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: ((1.354 * height) / 100),
          ),
          Center(
            child: Hero(
              tag: "$_lightIntensityHeroTag",
              transitionOnUserGestures: true,
              child: Image.asset(
                "assets/bulb.png",
                height: ((4.064 * height) / 100),
                width: ((4.064 * height) / 100),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(
              ((2.709 * height) / 100),
            ),
            child: Text(
              "Light Intensity",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((2.709 * height) / 100),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ((2.709 * height) / 100),
            ),
            child: Text(
              "Light intensity refers to the strength or amount of light produced by a specific lamp source. It is the measure of the wavelength-weighted power emitted by a light source.\n\nLight intensity varies depending on the lamp source and there are specific high and low light intensity fixtures, lamps, and bulbs. For example, high intensity discharge lamps emit a high light intensity, while fluorescent lamps are considered a “cool” or low intensity light source.",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 1.2,
                fontSize: ((2.167 * height) / 100),
              ),
            ),
          ),
          SizedBox(
            height: ((2.032 * height) / 100),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
