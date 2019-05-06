import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/models/appliance_model.dart';
import 'package:flutter_home_automation/models/room_model.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:rxdart/rxdart.dart';

class RoomPageBloc implements BlocBase {
  PublishSubject<bool> _loadingController;
  BehaviorSubject<double> _pageOffSetController;
  BehaviorSubject<String> _switchApplianceIdController;
  BehaviorSubject<bool> _switchStatusController;

  RoomPageBloc() {
    _loadingController = PublishSubject<bool>();
    _pageOffSetController = BehaviorSubject<double>();
    _switchApplianceIdController = BehaviorSubject<String>();
    _switchStatusController = BehaviorSubject<bool>();
  }

  Sink<bool> get _setLoadingStatus => _loadingController.sink;
  Observable<bool> get getLoadingStatus => _loadingController.stream;

  Sink<double> get _setPageOffSet => _pageOffSetController.sink;
  Observable<double> get getPageOffSet => _pageOffSetController.stream;

  Sink<String> get _setSwitchApplianceId => _switchApplianceIdController.sink;
  Observable<String> get getSwitchApplianceId =>
      _switchApplianceIdController.stream;

  Sink<bool> get _setSwitchStatus => _switchStatusController.sink;
  Observable<bool> get getSwitchStatus => _switchStatusController.stream;

  void setSwitchStatus(bool status) {
    _setSwitchStatus.add(status);
  }

  void setSwitchApplianceId(String id) {
    _setSwitchApplianceId.add(id);
  }

  void setPageOffSet(double offSet) {
    _setPageOffSet.add(offSet);
  }

  void setLoadingStatus(bool status) {
    _setLoadingStatus.add(status);
  }

  Future<RoomModel> getRoom(String roomId) async {
    RoomModel roomModel;
    List<ApplianceModel> applianceList = List<ApplianceModel>();
    ApplianceModel applianceModel;

    Map response = (await NetworkCalls.getRoom(roomId))["room"];

    for (Map appliances in response["appliances"]) {
      if (appliances["type"] == "READING") {
        applianceModel = ApplianceModel(
          appliances["_id"],
          appliances["arduinoId"],
          appliances["applianceName"],
          appliances["type"],
          appliances["pin"],
          appliances["status"] == null ? false : appliances["status"],
          reading: appliances["reading"],
        );
      } else {
        applianceModel = ApplianceModel(
          appliances["_id"],
          appliances["arduinoId"],
          appliances["applianceName"],
          appliances["type"],
          appliances["pin"],
          appliances["status"] == null ? false : appliances["status"],
        );
      }

      applianceList.add(applianceModel);
    }

    roomModel = RoomModel(
      response["_id"],
      response["userId"],
      response["roomName"],
      applianceList,
    );

    return roomModel;
  }

  @override
  void dispose() async {
    await _loadingController.drain();
    await _pageOffSetController.drain();
    await _switchApplianceIdController.drain();
    await _switchStatusController.drain();

    await _loadingController.close();
    await _pageOffSetController.close();
    await _switchApplianceIdController.close();
    await _switchStatusController.close();
  }
}
