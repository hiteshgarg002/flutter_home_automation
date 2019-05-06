class ArduinoModel {
  String _id, _arduinoId;
  List<dynamic> _unusedPinsList;

  ArduinoModel(this._id, this._arduinoId, this._unusedPinsList);

  String get id => _id;
  String get arduinoId => _arduinoId;
  List<dynamic> get unusedPinsList => _unusedPinsList;
}
