import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
  double height, width;
  String _name = "";

  @override
  void initState() {
    super.initState();

    _roomNameController = TextEditingController();

    _response = List();
    _roomsPageBloc = BlocProvider.of<RoomsPageBloc>(context);

    _getAllRooms(initialLoading: true);
    // _getReloadRoomsIO();
    // _getSharedPreferences();
  }

  Future<SharedPreferences> _getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Future _getAllRooms({@required bool initialLoading}) async {
    await _roomsPageBloc.getAndSetRoomsList();

    if (initialLoading) {
      _roomsPageBloc.setLoadingStatus(false);
    }
  }

  void _reloadRooms() {
    _roomsPageBloc.setLoadingStatus(true);
    _getAllRooms(initialLoading: true);
  }

  Widget _buildUserPhotoWidget() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: ((2.641 * height) / 100),
      child: Center(
        child: FutureBuilder<SharedPreferences>(
          future: _getSharedPreferences(),
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return CircleAvatar(
                  radius: ((2.641 * height) / 100),
                  backgroundColor: Colors.white,
                );
              case ConnectionState.active:
                return CircleAvatar(
                  radius: ((2.641 * height) / 100),
                  backgroundColor: Colors.white,
                );
              case ConnectionState.waiting:
                return CircleAvatar(
                  radius: ((2.641 * height) / 100),
                  backgroundColor: Colors.white,
                );
              case ConnectionState.done:
                _name = snapshot.data.getString("name");
                String photoUrl = snapshot.data.getString("photoUrl");

                if (photoUrl.isEmpty) {
                  return Text(
                    "${_name.substring(0, 1)}${_name.split(" ")[1].substring(0, 1)}",
                    style: TextStyle(
                      color: CustomColors.darkestGrey,
                      fontSize: ((2.0 * height) / 100),
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                } else {
                  return CircleAvatar(
                    radius: ((2.5 * height) / 100),
                    backgroundColor: Colors.white,
                    backgroundImage: CachedNetworkImageProvider(
                      "${DioAPI.baseURL}/$photoUrl",
                      cacheManager: DefaultCacheManager(),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget _buildCustomAppBarWidget() {
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
                  ((1.354 * height) / 100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildUserPhotoWidget(),
                    SizedBox(
                      height: ((0.948 * height) / 100),
                    ),
                    Text(
                      "Hi !",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ((2.438 * height) / 100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ((0.406 * height) / 100),
                    ),
                    Text(
                      "Your automated Rooms",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ((1.625 * height) / 100),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(((1.354 * height) / 100)),
                child: _buildCreateRoomButtonWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateRoomButtonWidget() {
    return Material(
      elevation: ((2.032 * height) / 100),
      type: MaterialType.button,
      color: Colors.lightBlue,
      shape: CircleBorder(
        side: BorderSide(
          color: Colors.white,
          style: BorderStyle.solid,
          width: ((0.203 * height) / 100),
        ),
      ),
      child: IconButton(
        tooltip: "Create Room",
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        iconSize: ((4.064 * height) / 100),
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
          } else if (!(_response[0] as Map).containsKey("newRoom")) {
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
    );
  }

  OutlineInputBorder _buildTextFieldOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(((3.386 * height) / 100)),
      borderSide: BorderSide(
        width: ((0.094 * height) / 100),
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
      cursorWidth: ((0.203 * height) / 100),
      cursorColor: Colors.black,
      style: TextStyle(
        fontSize: ((2.032 * height) / 100),
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
          left: ((1.354 * height) / 100),
          right: ((1.354 * height) / 100),
          top: ((1.083 * height) / 100),
          bottom: ((1.083 * height) / 100),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: "Room name",
        hintStyle: TextStyle(
          fontSize: ((1.828 * height) / 100),
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
              size: ((2.980 * height) / 100),
            ),
            SizedBox(
              width: ((0.948 * height) / 100),
            ),
            Text(
              "$content",
              style: TextStyle(
                color: Colors.white,
                fontSize: ((1.896 * height) / 100),
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

  Widget _buildNewTempRoomCardWidget() {
    return Card(
      margin: EdgeInsets.all(
        ((1.083 * height) / 100),
      ),
      color: Colors.white,
      elevation: ((1.354 * height) / 100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          ((2.032 * height) / 100),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((2.709 * height) / 100),
        ),
        child: StreamBuilder<bool>(
          initialData: false,
          stream: _roomsPageBloc.getRoomCreationLoadingStatus,
          builder: (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
            return !loadingSnapshot.data
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildNewRoomTextFieldWidget(),
                      SizedBox(
                        height: ((2.032 * height) / 100),
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
                              iconSize: ((4.605 * height) / 100),
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
                              iconSize: ((4.605 * height) / 100),
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
                      height: ((3.386 * height) / 100),
                      width: ((3.386 * height) / 100),
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
    );
  }

  Widget _buildRoomCardWidget(int index) {
    Map res = _response[index] as Map;

    return res.containsKey("newRoom")
        ? _buildNewTempRoomCardWidget()
        : GestureDetector(
            child: Card(
              margin: EdgeInsets.all(
                ((1.083 * height) / 100),
              ),
              color: Colors.white,
              elevation: ((1.354 * height) / 100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  ((2.032 * height) / 100),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ((2.709 * height) / 100),
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
                        fontSize: ((2.099 * height) / 100),
                      ),
                    ),
                    SizedBox(
                      height: ((0.677 * height) / 100),
                    ),
                    Text(
                      "1 person has access!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ((1.625 * height) / 100),
                      ),
                    ),
                    SizedBox(
                      height: ((2.032 * height) / 100),
                    ),
                    Text(
                      "${res["numDevices"].toString()} Devices",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: ((1.557 * height) / 100),
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
                  "reloadRooms": _reloadRooms,
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
                          ((2.709 * height) / 100),
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.black),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ((1.896 * height) / 100),
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
                      width: ((1.083 * height) / 100),
                    ),
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ((2.709 * height) / 100),
                        ),
                      ),
                      borderSide: BorderSide(color: Colors.black),
                      child: Text(
                        "Close",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ((1.896 * height) / 100),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              : Container(
                  height: ((2.709 * height) / 100),
                  width: ((2.709 * height) / 100),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: ((0.203 * height) / 100),
                    backgroundColor: Colors.transparent,
                  ),
                );
        },
      ),
      SizedBox(
        width: ((0.135 * height) / 100),
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
            borderRadius: BorderRadius.circular(((4.064 * height) / 100)),
          ),
          elevation: ((2.032 * height) / 100),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning,
                color: Colors.orange,
                size: ((3.251 * height) / 100),
              ),
              SizedBox(
                width: ((0.948 * height) / 100),
              ),
              Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: ((2.302 * height) / 100),
                ),
              ),
            ],
          ),
          content: Text(
            "Deleting room can't be undone.",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: ((2.032 * height) / 100),
            ),
          ),
          actions: _deleteDialogActions(res),
        );
      },
    );
  }

  Widget _buildRoomsSliverGridWidget() {
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
                    return _buildRoomCardWidget(index);
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
                        fontSize: ((2.032 * height) / 100),
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _sfKey,
      backgroundColor: CustomColors.grey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: CustomColors.grey,
            expandedHeight: height * 0.15,
            floating: true,
            flexibleSpace: _buildCustomAppBarWidget(),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: ((0.948 * height) / 100),
              top: ((0.948 * height) / 100),
              left: ((1.625 * height) / 100),
              right: ((1.625 * height) / 100),
            ),
            sliver: StreamBuilder<bool>(
              initialData: true,
              stream: _roomsPageBloc.getLoadingStatus,
              builder:
                  (BuildContext context, AsyncSnapshot<bool> loadingSnapshot) {
                return loadingSnapshot.data
                    ? _buildInitialLoadingWidget()
                    : _buildRoomsSliverGridWidget();
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
