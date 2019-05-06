import 'package:flutter/material.dart';
import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomsPageBloc implements BlocBase {
  SharedPreferences _prefs;

  PublishSubject<bool> _loadingController;
  PublishSubject<bool> _roomCreationLoadingController;
  BehaviorSubject<List> _roomsListController;
  PublishSubject<bool> _deleteRoomLoadingController;

  List _roomsList;

  RoomsPageBloc() {
    _roomsList = List();

    _loadingController = PublishSubject<bool>();
    _roomsListController = BehaviorSubject<List>();
    _roomCreationLoadingController = PublishSubject<bool>();
    _deleteRoomLoadingController = PublishSubject<bool>();
  }

  Sink<bool> get _setLoadingStatus => _loadingController.sink;
  Observable<bool> get getLoadingStatus => _loadingController.stream;

  Sink<List> get _setRoomsList => _roomsListController.sink;
  Observable<List> get getRoomsList => _roomsListController.stream;

  Sink<bool> get _setRoomCreationLoadingStatus =>
      _roomCreationLoadingController.sink;
  Observable<bool> get getRoomCreationLoadingStatus =>
      _roomCreationLoadingController.stream;

  Sink<bool> get _setDeleteRoomLoadingStatus => _deleteRoomLoadingController.sink;
  Observable<bool> get getDeleteRoomLoadingStatus => _deleteRoomLoadingController.stream;

  void setDeleteRoomLoadingStatus(bool status) {
    _setDeleteRoomLoadingStatus.add(status);
  }

  void setRoomCreationLoadingStatus(bool status) {
    _setRoomCreationLoadingStatus.add(status);
  }

  Future getAndSetRoomsList() async {
    _prefs = await SharedPreferences.getInstance();

    if (_roomsList.isNotEmpty) {
      _roomsList.clear();
    }

    _roomsList.addAll((await NetworkCalls.getRooms(
      _prefs.getString("userId"),
    ))["rooms"]);

    _setRoomsList.add(_roomsList);
  }

  void addTempRoom({@required Map roomData, @required bool emptyList}) {
    if (!emptyList) {
      _roomsList.insert(0, roomData);
    } else {
      _roomsList.add(roomData);
    }
    _setRoomsList.add(_roomsList);
  }

  void removeTempRoom() {
    _roomsList.removeAt(0);
    _setRoomsList.add(_roomsList);
  }

  void setLoadingStatus(bool status) {
    _setLoadingStatus.add(status);
  }

  @override
  void dispose() async {
    await _loadingController.drain();
    await _roomsListController.drain();
    await _roomCreationLoadingController.drain();
    await _deleteRoomLoadingController.drain();

    await _loadingController.close();
    await _roomsListController.close();
    await _roomCreationLoadingController.close();
    await _deleteRoomLoadingController.close();
  }
}
