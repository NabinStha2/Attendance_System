import 'dart:io';

import 'package:attendance_system/core/development/console.dart';
import 'package:attendance_system/utils/permission.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  // String? path;
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

  consolelog(directory);

  if (await directory?.exists() == false) {
    consolelog(await directory?.exists());
    await directory?.create(recursive: true);
  }

  // if (Platform.isAndroid || Platform.isIOS) {
  //   final Directory directory =
  //       await path_provider.getApplicationSupportDirectory();
  //   path = directory.path;
  // }
  // final String fileLocation = '$path/$fileName';
  // final File file = File(fileLocation);

  saveFile = File("${directory?.path}/$fileName");
  await saveFile.writeAsBytes(bytes, flush: true);
  if (Platform.isAndroid || Platform.isIOS) {
    await open_file.OpenFile.open("${directory?.path}/$fileName");
  }
}
