import 'package:dio/dio.dart';

class DioAPI {
  static Dio _dio;
  static String _ip = "192.168.43.222";
  static String _port = "8080";
  static String baseURL = "http://$_ip:$_port";

  static Dio getDioInstance() {
    try {
      if (_dio == null) {
        _dio = Dio();
        _dio.options.baseUrl = baseURL;
      }
    } on Exception catch (err) {
      print("Error - DioAPI :- ${err.toString()}");
    }

    return _dio;
  }
}
