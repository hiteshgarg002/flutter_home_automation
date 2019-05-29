import 'package:connectivity/connectivity.dart';

class Connection {
  static Future<bool> isConnected() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
