class ApplianceModel {
  String _id, _arduinoId, _applianceName, _applianceType;
  int _pin;
  double reading;
  bool _status;

  ApplianceModel(this._id, this._arduinoId, this._applianceName,
      this._applianceType, this._pin, this._status,
      {this.reading});

  String get id => _id;
  String get arduinoId => _arduinoId;
  String get applianceName => _applianceName;
  String get applianceType => _applianceType;
  int get pin => _pin;
  double get getReading => reading;
  bool get status => _status;

  set setStatus(bool status) {
    _status = status;
  }
}
