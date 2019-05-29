import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_home_automation/blocs/monitor_page_bloc.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';
import 'package:flutter_home_automation/utils/StatusNavBarColorChanger.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:fcharts/fcharts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HumidityPage extends StatefulWidget {
  @override
  _HumidityPageState createState() => _HumidityPageState();
}

class _HumidityPageState extends State<HumidityPage> {
  SharedPreferences _prefs;
  SocketIO _socketIO;
  MonitorPageBloc _monitorPageBloc;
  static double _completePercentage = 100.0;

  static final GlobalKey<AnimatedCircularChartState> _chartKey1 =
      GlobalKey<AnimatedCircularChartState>();
  final String _humidityHeroTag = "HUMIDITY";
  double height, width;

  @override
  void initState() {
    super.initState();

    _monitorPageBloc = BlocProvider.of<MonitorPageBloc>(context);
    _setupSocketIO();
  }

  Future _setUpSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Null> _setupSocketIO() async {
    await _setUpSharedPreferences();

    SocketIOManager manager = SocketIOManager();
    _socketIO = await manager.createInstance('${DioAPI.baseURL}');

    _socketIO.onConnect((dynamic data) {
      print("SocketIO Connected :- HumidityPage");
      _socketIO.emit("join", [_prefs.getString("userId")]);
    });

    _socketIO.onReconnect((dynamic data) {
      _socketIO.emit("join", [_prefs.getString("userId")]);
    });

    _socketIO.onConnectTimeout((dynamic data) {
      print("HumidityPage :- SocketIO ConnectTimeout :- ${data.toString()}");
      _socketIO.connect();
    });

    _socketIO.onReconnectError((dynamic error) {
      print("HumidityPage :- SocketIO ReconnectError :- ${error.toString()}");
    });

    _socketIO.onError((dynamic error) {
      print("HumidityPage :- SocketIO Error :- ${error.toString()}");
      _socketIO.connect();
    });

    _socketIO.onReconnectFailed((dynamic error) {
      print("HumidityPage :- SocketIO ReconnectFailed :- ${error.toString()}");
    });

    _socketIO.on("humidity", (dynamic data) {
      print("Hum from HumidityPage :- $data");
      _monitorPageBloc.setHumidityData((num.parse(data.toString()) / 10).toString());
      _chartKey1.currentState.updateData(
          _getProgressData((num.parse(data.toString()) / 10).toString()));
    });

    _socketIO.on("humweekly", (dynamic data) {
      print("Hum Weekly from HumidityPage :- $data");
      Map li = data;
      // print("Thu : ${li["thu"].toInt()}");

      var weeklyData = [
        ["Sun", "${li["sun"].toInt()}"],
        ["Mon", "${li["mon"].toInt()}"],
        ["Tue", "${li["tue"].toInt()}"],
        ["Wed", "${li["wed"].toInt()}"],
        ["Thu", "${li["thu"].toInt()}"],
        ["Fri", "${li["fri"].toInt()}"],
        ["Sat", "${li["sat"].toInt()}"],
      ];

      _monitorPageBloc.setWeeklyData(weeklyData);
    });

    _socketIO.connect();
  }

  static const initialData = [
    ["Sun", "10"],
    ["Mon", "8"],
    ["Tue", "20"],
    ["Wed", "15"],
    ["Thu", "45"],
    ["Fri", "8"],
    ["Sat", "20"],
  ];

  List<CircularStackEntry> _getProgressData(String percentage) {
    return <CircularStackEntry>[
      CircularStackEntry(
        <CircularSegmentEntry>[
          CircularSegmentEntry(
            double.parse(percentage),
            Colors.lightBlue,
            rankKey: 'Q1',
          ),
          CircularSegmentEntry(
            _completePercentage - double.parse(percentage),
            CustomColors.grey,
            rankKey: 'Q2',
          ),
        ],
        rankKey: 'Humidity',
      ),
    ];
  }

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
                      "Humidity",
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
              labelStyle: TextStyle(color: Colors.black),
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
                  StreamBuilder<String>(
                    initialData: "0",
                    stream: _monitorPageBloc.getHumidityData,
                    builder: (BuildContext context,
                        AsyncSnapshot<String> humSnapshot) {
                      return AnimatedCircularChart(
                        edgeStyle: SegmentEdgeStyle.round,
                        key: _chartKey1,
                        size: Size(
                          250.0,
                          250.0,
                        ),
                        duration: Duration(
                          milliseconds: 900,
                        ),
                        percentageValues: false,
                        holeLabel: "${humSnapshot.data}%",
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: ((2.438 * height) / 100),
                        ),
                        initialChartData: _getProgressData(humSnapshot.data),
                        holeRadius: 70.0,
                        chartType: CircularChartType.Radial,
                      );
                    },
                  ),
                  StreamBuilder<List<List<String>>>(
                    initialData: initialData,
                    stream: _monitorPageBloc.getWeeklyData,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<List<String>>> snapshot) {
                      return LineChart(
                        lines: [
                          Line<List<String>, String, String>(
                            data: snapshot.data,
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
                      );
                    },
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
              tag: "$_humidityHeroTag",
              transitionOnUserGestures: true,
              child: Image.asset(
                "assets/humidity_2.png",
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
              "Humidity",
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
              "Humidity is the amount of water vapour present in air. Water vapour, the gaseous state of water, is generally invisible to the human eye. Humidity indicates the likelihood for precipitation, dew, or fog to be present. The amount of water vapour needed to achieve saturation increases as the temperature increases. As the temperature of a parcel of air decreases it will eventually reach the saturation point without adding or losing water mass. The amount of water vapour contained within a parcel of air can vary significantly.",
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
    if (_socketIO != null) {
      _socketIO.off("humidity");

      _socketIO.emit('dis', [_prefs.getString("userId")]);
    }
    super.dispose();
  }
}
