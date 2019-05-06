import 'package:flutter_home_automation/models/appliance_model.dart';

class RoomModel {
  String _id, _userId, _roomName;
  List<ApplianceModel> _applianceList;

  RoomModel(this._id, this._userId, this._roomName, this._applianceList);

  String get id => _id;
  String get userId => _userId;
  String get roomName => _roomName;
  List<ApplianceModel> get applianceList => _applianceList;
}
