import 'package:flutter_home_automation/blocs/provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MonitorPageBloc implements BlocBase {
  PublishSubject<bool> _motionDetectionController;
  BehaviorSubject<SharedPreferences> _sharedPreferenceController;
  PublishSubject<Map<String, dynamic>> _weatherController;
  BehaviorSubject<bool> _motionDetectionEnabledController;
  BehaviorSubject<String> _humidityController;
  BehaviorSubject<String> _temperatureController;
  BehaviorSubject<String> _lightIntensityController;
  PublishSubject<List<List<String>>> _weeklyDataController;

  MonitorPageBloc() {
    _motionDetectionController = PublishSubject<bool>();
    _sharedPreferenceController = BehaviorSubject<SharedPreferences>();
    _weatherController = PublishSubject<Map<String, dynamic>>();
    _motionDetectionEnabledController = BehaviorSubject<bool>();
    _humidityController = BehaviorSubject<String>();
    _temperatureController = BehaviorSubject<String>();
    _lightIntensityController = BehaviorSubject<String>();
    _weeklyDataController = PublishSubject<List<List<String>>>();
  }

  Sink<bool> get _setMotionDetectedStatus => _motionDetectionController.sink;
  Observable<bool> get getMotionDetectedStatus =>
      _motionDetectionController.stream;

  Sink<SharedPreferences> get _setSharedPreferences =>
      _sharedPreferenceController.sink;
  Observable<SharedPreferences> get getSharedPreferences =>
      _sharedPreferenceController.stream;

  Sink<Map<String, dynamic>> get _setWeather => _weatherController.sink;
  Observable<Map<String, dynamic>> get getWeather => _weatherController.stream;

  Sink<bool> get _setMotionDetectionEnabledStatus =>
      _motionDetectionEnabledController.sink;
  Observable<bool> get getMotionDetectionEnabledStatus =>
      _motionDetectionEnabledController.stream;

  Sink<String> get _setHumidityData => _humidityController.sink;
  Observable<String> get getHumidityData => _humidityController.stream;

  Sink<String> get _setTempData => _temperatureController.sink;
  Observable<String> get getTempData => _temperatureController.stream;

  Sink<String> get _setLIData => _lightIntensityController.sink;
  Observable<String> get getLIData => _lightIntensityController.stream;

  Sink<List<List<String>>> get _setWeeklyData => _weeklyDataController.sink;
  Observable<List<List<String>>> get getWeeklyData =>
      _weeklyDataController.stream;

  void setWeeklyData(List<List<String>> data) {
    _setWeeklyData.add(data);
  }

  void setTempData(String data) {
    _setTempData.add(data);
  }

  void setLIData(String data) {
    _setLIData.add(data);
  }

  void setHumidityData(String data) {
    _setHumidityData.add(data);
  }

  void setMotionDetectionEnabledStatus(bool status) {
    _setMotionDetectionEnabledStatus.add(status);
  }

  void setWeather(Map weatherData) {
    _setWeather.add(weatherData);
  }

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
    await _weatherController.drain();
    await _motionDetectionEnabledController.drain();
    await _humidityController.drain();
    await _temperatureController.drain();
    await _lightIntensityController.drain();
    await _weeklyDataController.drain();

    await _motionDetectionController.close();
    await _sharedPreferenceController.close();
    await _weatherController.close();
    await _motionDetectionEnabledController.close();
    await _humidityController.close();
    await _temperatureController.close();
    await _lightIntensityController.close();
    await _weeklyDataController.close();
  }
}
