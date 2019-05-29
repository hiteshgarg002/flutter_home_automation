import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<Null> requestPermissions(
      List<PermissionGroup> reqPermissions) async {
    // Map<PermissionGroup, PermissionStatus> permissions =
    //     await PermissionHandler().requestPermissions(reqPermissions);
    await PermissionHandler().requestPermissions(reqPermissions);
    //return permissions;
  }

  static Future<PermissionStatus> checkPermissionsStatus(
      PermissionGroup checkPermissions) async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(checkPermissions);
    // print("Permission Status :- ${permission.toString()}");
    return permission;
  }

  static Future<Null> openAppSettings() async {
    bool isOpened = await PermissionHandler().openAppSettings();

    return isOpened;
  }

  static Future<Null> showRequestPermissionRationale() async {
    bool isShown = await PermissionHandler()
        .shouldShowRequestPermissionRationale(PermissionGroup.contacts);

    return isShown;
  }
}
