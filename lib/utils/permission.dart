import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

Future<bool> askPermission() async {
  if (Platform.isAndroid) {
    Permission permission = Permission.storage;
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
  return false;
}