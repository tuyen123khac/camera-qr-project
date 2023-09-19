import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  
  static Future<PermissionStatus> checkCameraPermission() async {
    var status = await Permission.camera.status;
    return status;
  }

  static Future<void> requestCameraPermission() async {
    await Permission.camera.request();
  }

}
