import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:flutter_home_automation/models/auduino_model.dart';
import 'package:flutter_home_automation/networks/network_calls.dart';
import 'package:flutter_home_automation/utils/appliance_type_enum.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAppliancePageBloc implements BlocBase {
  SharedPreferences _prefs;

  PublishSubject<bool> _loadingController;
  BehaviorSubject<String> _arduinoDropDownValueController;
  PublishSubject<int> _pinDropDownValueController;
  BehaviorSubject<ApplianceType> _applianceTypeController;

  AddAppliancePageBloc() {
    _loadingController = PublishSubject<bool>();
    _arduinoDropDownValueController = BehaviorSubject<String>();
    _pinDropDownValueController = PublishSubject<int>();
    _applianceTypeController = BehaviorSubject<ApplianceType>();
  }

  Sink<bool> get _setLoadingStatus => _loadingController.sink;
  Observable<bool> get getLoadingStatus => _loadingController.stream;

  Sink<String> get _setArduinoDropDownValue =>
      _arduinoDropDownValueController.sink;
  Observable<String> get getArduinoDropDownValue =>
      _arduinoDropDownValueController.stream;

  Sink<int> get _setPinDropDownValue => _pinDropDownValueController.sink;
  Observable<int> get getPinDropDownValue => _pinDropDownValueController.stream;

  Sink<ApplianceType> get _setApplianceType => _applianceTypeController.sink;
  Observable<ApplianceType> get getApplianceType =>
      _applianceTypeController.stream;

  void setApplianceType(ApplianceType type) {
    _setApplianceType.add(type);
  }

  void setPinDropDownValue(int value) {
    _setPinDropDownValue.add(value);
  }

  void setArduinoDropDownValue(String value) {
    _setArduinoDropDownValue.add(value);
  }

  Future<List<ArduinoModel>> getAllArduinos() async {
    List<ArduinoModel> _arduinoList = List<ArduinoModel>();
    _prefs = await SharedPreferences.getInstance();

    List<dynamic> res = (await NetworkCalls.getAllArduinos(
      _prefs.getString("userId"),
    ))["arduinos"];

    for (dynamic response in res) {
      _arduinoList.add(
        ArduinoModel(
          response["_id"],
          response["arduinoId"],
          response["unusedPins"],
        ),
      );
    }

    return _arduinoList;
  }

  void setLoadingStatus(bool status) {
    _setLoadingStatus.add(status);
  }

  @override
  void dispose() async {
    await _loadingController.drain();
    await _arduinoDropDownValueController.drain();
    await _pinDropDownValueController.drain();
    await _applianceTypeController.drain();

    await _loadingController.close();
    await _arduinoDropDownValueController.close();
    await _pinDropDownValueController.close();
    await _applianceTypeController.close();
  }
}
