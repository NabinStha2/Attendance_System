import 'dart:io';

import 'package:attendance_system/core/development/console.dart';
import 'package:attendance_system/utils/permission.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  Directory? directory;
  File saveFile;
  directory = await getExternalStorageDirectory();
  String newPath = "";
  List<String> paths = directory?.path.split("/") ?? [];
  if (await askPermission()) {
    if (paths.isNotEmpty == true) {
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/$folder";
        } else {
          break;
        }
      }
      directory = Directory("$newPath/Attendance");
    }
  }

  if (await directory?.exists() == false) {
    await directory?.create(recursive: true);
  }

  saveFile = File("${directory?.path}/$fileName");
  await saveFile.writeAsBytes(bytes, flush: true);
  consolelog(saveFile);
  if (Platform.isAndroid) {
    await open_file.OpenFile.open("${directory?.path}/$fileName");
  }
}
