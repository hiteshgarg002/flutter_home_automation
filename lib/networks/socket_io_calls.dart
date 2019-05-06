import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_home_automation/networks/dio_api.dart';

class SocketIOCalls {
  static SocketIOManager _socketIOManager;
  static SocketIO socketIO;

  // static Future<Null> testSocket1() async {
  //   SocketIOManager manager = SocketIOManager();
  //   SocketIO socket =
  //       await manager.createInstance('http://192.168.43.222:8080');
  //   socket.onConnect((data) {
  //     print("connected...");
  //     // print(data);
  //     // socket.emit("message", ["Hello world!"]);
  //   });
  //   socket.on("channel1", (data) {
  //     print(data.toString());
  //   });

  //   socket.connect();
  // }

  static Future<SocketIO> _createSocketIO({@required String id}) async {
    try {
      _socketIOManager = SocketIOManager();

      socketIO =
          await _socketIOManager.createInstance("${DioAPI.baseURL}");

      socketIO.onConnect((data) {
        print("Connected!");

        socketIO.emit("join", [id]);
      });

      // socketIO.on("test", (data) {
      //   print("Data :- $data");
      // });

      //  socketIO.on("test", (data) {
      //   print("Data aagya:- $data");
      // });

      // socketIO.on("reloadroom", (data) {
      //   print("Reload :- "+data);
      // });

      socketIO.connect();
    } on PlatformException catch (err) {
      print("Error in Socket IO :- ${err.message}");
    }
    return socketIO;
  }

  static Future<SocketIO> getSocketIO({@required String id}) async {
    if (socketIO == null) {
      socketIO = await _createSocketIO(id: id);
    }

    return socketIO;
  }
}
