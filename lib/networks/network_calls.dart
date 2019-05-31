import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';

class NetworkCalls {
  // static Future<String> uploadPhoto(
  //     File imageFile, PhotoType photoType, String caption) async {
  //   Future<String> res;

  //   http.ByteStream stream = new http.ByteStream(
  //     DelegatingStream.typed(
  //       imageFile.openRead(),
  //     ),
  //   );
  //   final int length = await imageFile.length();

  //   final String uploadURL = photoType == PhotoType.PHOTO
  //       ? "http://192.168.43.222:8080/feed/upload/photo"
  //       : "http://192.168.43.222:8080/feed/upload/profile-photo";

  //   Uri uri = Uri.parse(uploadURL);

  //   http.MultipartRequest request = http.MultipartRequest("POST", uri);
  //   http.MultipartFile multipartFile = http.MultipartFile(
  //     photoType == PhotoType.PHOTO ? "photo" : "profile_photo",
  //     stream,
  //     length,
  //     filename: photoType == PhotoType.PHOTO
  //         ? basename(imageFile.path.split("/").last)
  //         : "USER_NAME",
  //     contentType: MediaType("image", "jpg"),
  //   );

  //   request.files.add(multipartFile);

  //   http.StreamedResponse response = await request.send();

  //   response.stream.transform(utf8.decoder).listen((String postId) {
  //     dynamic data = json.decode(postId);
  //     // print("Value :- ${data["postId"]}");
  //     res = _createPost(caption, data["postId"]);
  //   });

  //   print("Final response :- ${await res}");
  //   return await res;
  // }

  static Future<Map> _uploadPhoto(File imageFile) async {
    final String uploadPath = "/auth/uploadPhoto";

    Dio dio = DioAPI.getDioInstance();
    Response response;

    // FormData sets the contentType to "multipart/form-data" and hence we are not able to send the text data with it.
    // Source of info :- https://github.com/flutterchina/dio/issues/88
    FormData formData = FormData.from({
      "photo": UploadFileInfo(
        imageFile,
        basename(imageFile.path.split("/").last),
        contentType: ContentType("image", "jpg"),
      ),
    });

    response = await dio.post(
      uploadPath,
      data: formData,
      options: Options(responseType: ResponseType.json),
      onSendProgress: (int sent, int total) {
        // print("Sent :- $sent and total :- $total");
      },
    );

    final Map res = response.data;
    return res;
  }

  static Future<Map> updatePhoto(String userId, File imageFile) async {
    Map uploadRes = Map();

    uploadRes = await _uploadPhoto(imageFile);

    final String updatePhotoPath = "/auth/postUpdatePhoto";

    Dio dio = DioAPI.getDioInstance();
    Response response;

    response = await dio.put(
      updatePhotoPath,
      data: {
        "userId": userId,
        "photoUrl":
            uploadRes.containsKey("photoUrl") ? uploadRes["photoUrl"] : "",
      },
      options: Options(
        responseType: ResponseType.json,
      ),
    );

    final Map res = response.data;

    return res;
  }

  // static Future<Map> signup(
  //     Map<String, String> userData, File imageFile) async {
  //   Map uploadRes = Map();

  //   if (imageFile != null) {
  //     uploadRes.clear();

  //     uploadRes.addAll(await _uploadPhoto(imageFile));
  //   }

  //   final String signupPath = "/auth/postSignup";

  //   Dio dio = DioAPI.getDioInstance();
  //   Response response;

  //   response = await dio.post(
  //     signupPath,
  //     data: {
  //       "name": userData["name"],
  //       "email": userData["email"],
  //       "phone": userData["phone"],
  //       "password": userData["password"],
  //       "photoUrl":
  //           uploadRes.containsKey("photoUrl") ? uploadRes["photoUrl"] : "",
  //     },
  //     options: Options(
  //       responseType: ResponseType.json,
  //     ),
  //   );

  //   final Map res = response.data;

  //   return res;
  // }

  static Future<Map> login(Map<String, String> userData) async {
    final String loginPath = "/auth/postLogin";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.post(
        loginPath,
        data: {
          "email": userData["email"],
          "password": userData["password"],
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;

      // print("Response aagya :- $res");
    } on Exception catch (err) {
      print("Error - NetworkCalls - login :- ${err.toString()}");
    }

    return res;
  }

  static Future getRooms(String userId) async {
    final String roomsPath = "/room/getAllRooms";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        roomsPath,
        queryParameters: <String, dynamic>{
          "userId": userId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - getRooms :- ${err.toString()}");
    }

    return res;
  }

  static Future<Map> getRoom(String roomId) async {
    final String roomPath = "/room/getRoom";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        roomPath,
        queryParameters: <String, dynamic>{
          "roomId": roomId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - getRoom :- ${err.toString()}");
    }

    return res;
  }

  static Future<Map> createRoom(String userId, String roomName) async {
    final String createRoomPath = "/room/postRoom";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.post(
        createRoomPath,
        data: {
          "roomName": roomName,
          "userId": userId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - createRoom :- ${err.toString()}");
    }
    return res;
  }

  static Future getAllArduinos(String userId) async {
    final String roomsPath = "/room/getAllArduinos";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        roomsPath,
        queryParameters: <String, dynamic>{
          "userId": userId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - getAllArduinos :- ${err.toString()}");
    }

    return res;
  }

  static Future<Map> addAppliance({
    @required String roomId,
    @required String applianceName,
    @required String arduinoId,
    @required int pin,
    @required String applianceType,
    @required String userId,
  }) async {
    final String addAppliancePath = "/room/postAppliance";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.post(
        addAppliancePath,
        data: {
          "roomId": roomId,
          "userId": userId,
          "applianceName": applianceName,
          "arduinoId": arduinoId,
          "pin": pin,
          "applianceType": applianceType,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - addAppliance :- ${err.toString()}");
    }
    return res;
  }

  static Future<bool> changeApplianceStatus(
      bool status, String applianceId, String roomId) async {
    final String changeApplianceStatusPath = "/room/postApplianceStatus";
    bool statusRes;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.post(
        changeApplianceStatusPath,
        data: {
          "status": status,
          "applianceId": applianceId,
          "roomId": roomId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      statusRes = response.data["status"];
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - changeApplianceStatus :- ${err.toString()}");
    }
    return statusRes;
  }

  static Future<bool> deteleAppliance(Map applianceData) async {
    String userId = applianceData["userId"];
    String roomId = applianceData["roomId"];
    String applianceId = applianceData["applianceId"];
    String arduinoId = applianceData["arduinoId"];
    int pin = applianceData["pin"];

    final String deleteAppliancePath =
        "/room/postDeleteAppliance/$userId/$roomId/$applianceId/$arduinoId/$pin";

    bool deleteRes;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.delete(
        deleteAppliancePath,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      deleteRes = response.data["deleteStatus"];
    } on Exception catch (err) {
      print("Error - NetworkCalls - deteleAppliance :- ${err.toString()}");
    }
    return deleteRes;
  }

  static Future<bool> deteleRoom(Map applianceData) async {
    String userId = applianceData["userId"];
    String roomId = applianceData["roomId"];

    final String deleteRoomPath = "/room/postDeleteRoom/$userId/$roomId";

    bool deleteRes;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.delete(
        deleteRoomPath,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      deleteRes = response.data["deleted"];
    } on Exception catch (err) {
      print("Error - NetworkCalls - deteleAppliance :- ${err.toString()}");
    }
    return deleteRes;
  }

  static Future deletePhoto(String userId, String photoUrl) async {
    final String deleteRoomPath = "/auth/postDeletePhoto/$userId/$photoUrl";

    try {
      Dio dio = DioAPI.getDioInstance();

      await dio.delete(
        deleteRoomPath,
        options: Options(
          responseType: ResponseType.json,
        ),
      );
    } on Exception catch (err) {
      print("Error - NetworkCalls - deletePhoto :- ${err.toString()}");
    }
  }

  static Future<Map> updateName(String userId, String name) async {
    final String updateNamePath = "/auth/postUpdateName";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.put(
        updateNamePath,
        data: {
          "userId": userId,
          "name": name,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - updateName :- ${err.toString()}");
    }

    return res;
  }

  static Future getRoomsAppliancesCount(String userId) async {
    final String roomsPath = "/room/getRoomsAppliancesCount";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        roomsPath,
        queryParameters: <String, dynamic>{
          "userId": userId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - getRoomsAppliancesCount :- ${err.toString()}");
    }

    return res;
  }

  static Future<Map<String, dynamic>> getWeather() async {
    // String gwaliorUrl="https://api.apixu.com/v1/current.json?key=0811bc94f11146aaa1b180422191404&q=Gwalior";
    String gwaliorUrl = "https://api.apixu.com/v1/current.json";

    Map<String, dynamic> res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        gwaliorUrl,
        queryParameters: <String, String>{
          "key": "YOUR API KEY",
          "q": "PLACE",
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );
      // print("Weather Res :- ${response.data}");

      res = response.data;
    } on Exception catch (err) {
      print("Error - NetworkCalls - getWeather :- ${err.toString()}");
    }

    return res;
  }

  static Future<bool> setMotionDetectionEnabledStatus(
      String userId, bool status) async {
    bool statusRes = !status;

    String path = "/home/postMotionDetectionEnabledStatus";

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.put(
        path,
        data: {
          "userId": userId,
          "status": status,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      statusRes = response.data["status"];
    } on Exception catch (err) {
      print("Error - NetworkCalls - deteleAppliance :- ${err.toString()}");
    }
    return statusRes;
  }

  static Future<Map> getMotionDetectionEnabledStatus(String userId) async {
    final String mdEnabledStatusPath = "/home/getMotionDetectionEnabledStatus";
    Map res;

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        mdEnabledStatusPath,
        queryParameters: <String, dynamic>{
          "userId": userId,
        },
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      res = response.data;
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - getRoomsAppliancesCount :- ${err.toString()}");
    }

    return res;
  }

  static Future<bool> setTempBulbButtonStatus(int led, bool status) async {
    bool statusRes = !status;

    String path = "http://192.168.43.129/";

    try {
      Dio dio = Dio();
      Response response;

      response = await dio.get(
        path,
        queryParameters: {"led$led": status ? "on" : "off"},
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      // statusRes = response.data["status"];
      statusRes = response.data == "1" ? true : false;
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - setTempBulbButtonStatus :- ${err.toString()}");
    }
    return await putTempBulbButtonStatus(statusRes, led);
  }

  static Future<bool> putTempBulbButtonStatus(bool status, int bulb) async {
    bool statusRes;
    String path = "/room/putBulbButtonStatus";

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.put(
        path,
        data: {"status": status, "bulb": bulb},
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      statusRes = response.data["status"];
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - postTempAutoModeStatus :- ${err.toString()}");
    }

    return statusRes;
  }

  static Future<bool> setTempAutoModeStatus(bool status) async {
    bool statusRes = !status;

    String path = "http://192.168.43.129/";

    try {
      Dio dio = Dio();
      Response response;

      response = await dio.get(
        path,
        queryParameters: {"automode": status ? "on" : "off"},
        options: Options(
          responseType: ResponseType.plain,
        ),
      );

      statusRes = response.data == "1" ? true : false;
    } on Exception catch (err) {
      print("Error - NetworkCalls - deteleAppliance :- ${err.toString()}");
    }
    return await putTempAutoModeStatus(statusRes);
  }

  static Future<bool> putTempAutoModeStatus(bool status) async {
    bool statusRes;
    String path = "/room/putAutoModeStatus";

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.put(
        path,
        data: {"automode": status},
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      statusRes = response.data["status"];
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - postTempAutoModeStatus :- ${err.toString()}");
    }

    return statusRes;
  }

  static Future<Map> getTempAutoModeStatus() async {
    Map statusRes;
    String path = "/room/getAutoModeStatus";

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        path,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      statusRes = response.data;
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - getTempAutoModeStatus :- ${err.toString()}");
    }
    return statusRes;
  }

  static Future<Map> getTempBulbButtonStatus() async {
    Map statusRes;
    String path = "/room/getBulbButtonStatus";

    try {
      Dio dio = DioAPI.getDioInstance();
      Response response;

      response = await dio.get(
        path,
        options: Options(
          responseType: ResponseType.json,
        ),
      );

      statusRes = response.data;
    } on Exception catch (err) {
      print(
          "Error - NetworkCalls - getTempBulbButtonStatus :- ${err.toString()}");
    }
    return statusRes;
  }
}
