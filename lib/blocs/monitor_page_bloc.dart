import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitorPageBloc implements BlocBase {
  PublishSubject<bool> _motionDetectionController;
  BehaviorSubject<SharedPreferences> _sharedPreferenceController;

  MonitorPageBloc() {
    _motionDetectionController = PublishSubject<bool>();
    _sharedPreferenceController = BehaviorSubject<SharedPreferences>();
  }

  Sink<bool> get _setMotionDetectedStatus => _motionDetectionController.sink;
  Observable<bool> get getMotionDetectedStatus =>
      _motionDetectionController.stream;

  Sink<SharedPreferences> get _setSharedPreferences =>
      _sharedPreferenceController.sink;
  Observable<SharedPreferences> get getSharedPreferences =>
      _sharedPreferenceController.stream;

  void setSharedPreferences(SharedPreferences prefs) {
    _setSharedPreferences.add(prefs);
  }

  void setMotionDetectedStatus(bool status) {
    _setMotionDetectedStatus.add(status);
  }

  @override
  void dispose() async {
    await _motionDetectionController.drain();
    await _sharedPreferenceController.drain();

    await _motionDetectionController.close();
    await _sharedPreferenceController.close();
  }
}
