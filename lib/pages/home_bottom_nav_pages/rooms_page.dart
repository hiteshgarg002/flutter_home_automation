import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/blocs/rooms_page_bloc.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:navigate/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  RoomsPageBloc _roomsPageBloc;
  SharedPreferences _prefs;
  List _response;
  final GlobalKey<ScaffoldState> _sfKey = GlobalKey<ScaffoldState>();
  TextEditingController _roomNameController;

  @override
  void initState() {
    super.initState();

    _roomNameController = TextEditingController();

    _response = List();
    _roomsPageBloc = BlocProvider.of<RoomsPageBloc>(context);

    _getAllRooms(initialLoading: true);
    _getReloadRoomsIO();
  }

  Future _getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future _getAllRooms({@required bool initialLoading}) async {
    await _roomsPageBloc.getAndSetRoomsList();

    if (initialLoading) {
      _roomsPageBloc.setLoadingStatus(false);
    }
  }

  Future<Null> _getReloadRoomsIO() async {
    await _getSharedPreferences();

    SocketIOManager manager = SocketIOManager();
    SocketIO socket = await manager.createInstance('${DioAPI.baseURL}');
    socket.onConnect((data) {
      socket.emit("join", [_prefs.getString("userId")]);
    });
    socket.on("reloadrooms", (data) {
      _roomsPageBloc.setLoadingStatus(true);
      _getAllRooms(initialLoading: true);
    });

    socket.connect();
  }

  Widget _buildCustomAppBarWidget(double width, double height) {
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background: Container(
        color: CustomColors.grey,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(
                  10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 19.5,
                      child: CircleAvatar(
                        radius: 18.5,
                        backgroundImage: AssetImage(
                          "assets/hitesh_cropped.jpg",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Text(
                      "Hi Hitesh!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      "Your automated Rooms",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Material(
                  elevation: 15.0, type: MaterialType.button,
                  // shadowColor: Colors.transparent,
                  color: Colors.lightBlue,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: Colors.white,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    iconSize: 30.0,
                    onPressed: () {
                      Map roomData = {
                        "newRoom": true,
                        "tempRoomId": _response.length,
                      };

                      if (_response.isEmpty) {
                        _roomsPageBloc.addTempRoom(
                          roomData: roomData,
                          emptyList: true,
                        );
                      } else if (!(_response[0] as Map)
                          .containsKey("newRoom")) {
                        _roomsPageBloc.addTempRoom(
                          roomData: roomData,
                          emptyList: false,
                        );
                      } else {
                        _showSnackBar(
                          "Can't add more than 1 room at a time.",
                          Icons.warning,
                        );
                      }
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

  OutlineInputBorder _buildTextFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        width: 0.7,
        color: Colors.black,
        style: BorderStyle.solid,
      ),
    );
  }

  Widget _buildNewRoomTextFieldWidget() {
    return TextField(
      controller: _roomNameController,
      scrollPadding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      keyboardType: TextInputType.text,
      cursorWidth: 1.5,
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        disabledBorder: _buildTextFieldOutlineInputBorder(),
        focusedBorder: _buildTextFieldOutlineInputBorder(),
        errorBorder: _buildTextFieldOutlineInputBorder(),
        focusedErrorBorder: _buildTextFieldOutlineInputBorder(),
        border: _buildTextFieldOutlineInputBorder(),
        enabledBorder: _buildTextFieldOutlineInputBorder(),
        contentPadding: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 8.0,
          bottom: 8.0,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Room name",
        hintStyle: TextStyle(
          fontSize: 13.5,
          color: Colors.grey,
        ),
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: () {
        FocusScope.of(context).detach();
      },
    );
  }

  void _showSnackBar(String content, IconData icon) {
    _sfKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: CustomColors.grey,
        content: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.amber,
              size: 22.0,
            ),
            SizedBox(
              width: 7.0,
            ),
            Text(
              "$content",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future _createRoom() async {
    if (_roomNameController.text.isNotEmpty) {
      _roomsPageBloc.setRoomCreationLoadingStatus(true);

      Map response = await NetworkCalls.createRoom(
        _prefs.getString("userId"),
        _roomNameController.text,
      );

      _roomNameController.clear();

      _roomsPageBloc.setRoomCreationLoadingStatus(false);

      if (response.containsKey("error")) {
        _roomsPageBloc.removeTempRoom();

        _showSnackBar(
          "Error creating room!",
          Icons.error,
        );
      } else if (response.containsKey("room")) {
        _roomsPageBloc.removeTempRoom();

        _showSnackBar(
          "Room Created!",
          Icons.tag_faces,
        );

        _getAllRooms(initialLoading: false);
      }
    } else {
      _showSnackBar(
        "Room name must not be empty!",
        Icons.warning,
      );
    }
  }

  Widget _buildRoomCardWidget(double height, double width, int index) {
    Map res = _response[index] as Map;

    return res.containsKey("newRoom")
        ? Card(
            margin: EdgeInsets.all(
              8.0,
            ),
            color: Colors.white,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                ((2.032 * height) / 100),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: StreamBuilder<bool>(
                initialData: false,
                stream: _roomsPageBloc.getRoomCreationLoadingStatus,
                builder: (BuildContext context,
                    AsyncSnapshot<bool> loadingSnapshot) {
                  return !loadingSnapshot.data
                      ? Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _buildNewRoomTextFieldWidget(),
                            SizedBox(
                              height: 15.0,
                            ),
                            Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.black,
                                    ),
                                    iconSize: 34.0,
                                    onPressed: () {
                                      _roomsPageBloc.removeTempRoom();
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.done,
                                      color: Colors.black,
                                    ),
                                    iconSize: 34.0,
                                    onPressed: () async {
                                      FocusScope.of(context).detach();
                                      await _createRoom();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                            height: 25.0,
                            width: 25.0,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                                strokeWidth: 2.0,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          )
        : GestureDetector(
            child: Card(
              margin: EdgeInsets.all(
                8.0,
              ),
              color: Colors.white,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ((2.032 * height) / 100),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${res["roomName"]}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "1 person has access!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "${res["numDevices"].toString()} Devices",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              Navigate.navigate(
                context,
                "/roomPage",
                arg: <String, dynamic>{
                  "roomId": res["_id"],
                },
                transactionType: TransactionType.fadeIn,
              );
            },
            onLongPress: () {
              _showDeleteDialog(res);
            },
          );
  }

  List<Widget> _deleteDialogActions(Map res) {
    return <Widget>[
      StreamBuilder<bool>(
        initialData: false,
        stream: _roomsPageBloc.getDeleteRoomLoadingStatus,
        builder: (BuildContext context,
            AsyncSnapshot<bool> deleteRoomLoadingSnapshot) {
          return !deleteRoomLoadingSnapshot.data
              ? Row(
                  children: <Widget>[
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.black),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                      onPressed: () async {
                        _roomsPageBloc.setDeleteRoomLoadingStatus(true);
                        await NetworkCalls.deteleRoom({
                          "roomId": res["_id"],
                          "userId": _prefs.getString("userId"),
                        });
                        await _getAllRooms(initialLoading: false);
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.black),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : Container(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 1.5,
                    backgroundColor: Colors.transparent,
                  ),
                );
        },
      ),
      SizedBox(
        width: 1.0,
      ),
    ];
  }

  void _showDeleteDialog(Map res) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          elevation: 15.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning,
                color: Colors.orange,
                size: 24.0,
              ),
              SizedBox(
                width: 7.0,
              ),
              Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          content: Text(
            "Deleting room can't be undone.",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 15.0,
            ),
          ),
          actions: _deleteDialogActions(res),
        );
      },
    );
  }

  Widget _buildRoomsSliverGridWidget(double height, double width) {
    return StreamBuilder<List>(
      stream: _roomsPageBloc.getRoomsList,
      builder: (BuildContext context, AsyncSnapshot<List> roomListSnapshot) {
        if (roomListSnapshot.hasData) {
          if (_response != null && _response.isNotEmpty) {
            _response.clear();
          }

          _response.addAll(roomListSnapshot.data);
        }

        return roomListSnapshot.hasData && roomListSnapshot.data.length > 0
            ? SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _buildRoomCardWidget(height, width, index);
                  },
                  childCount: roomListSnapshot.data.length,
                ),
              )
            : SliverToBoxAdapter(
                child: Container(
                  height: height,
                  child: Center(
                    child: Text(
                      "No rooms found!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildInitialLoadingWidget() {
    return SliverToBoxAdapter(
      child: Center(
        child: Container(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 2.0,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _sfKey,
      backgroundColor: CustomColors.grey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: CustomColors.grey,
            expandedHeight: height * 0.145,
            floating: true,
            flexibleSpace: _buildCustomAppBarWidget(width, height),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: 7.0,
              top: 7.0,
              left: 12.0,
              right: 12.0,
            ),
            sliver: StreamBuilder<bool>(
              initialData: true,
              stream: _roomsPageBloc.getLoadingStatus,
              builder:
                  (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
                return loadingSnapshot.data
                    ? _buildInitialLoadingWidget()
                    : _buildRoomsSliverGridWidget(height, width);
              },
            ),
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
