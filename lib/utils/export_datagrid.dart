import 'package:attendance_system/utils/save_file.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../core/app/states.dart';

Future<void> exportDataGridToExcel() async {
  // final Workbook workbook = sfDataGridKey.currentState!.exportToExcelWorkbook();
  // final List<int> bytes = workbook.saveAsStream();
  // workbook.dispose();
  // await saveAndLaunchFile(bytes,
  //     'Attendance${DateTime.now().day}${DateTime.now().millisecond}.xlsx');
  final Workbook workbook = Workbook();
  final Worksheet worksheet = workbook.worksheets[0];
  sfDataGridKey.currentState!.exportToExcelWorksheet(worksheet);
  final List<int> bytes = workbook.saveAsStream();
  await saveAndLaunchFile(bytes,
      'Attendance${DateTime.now().day}${DateTime.now().millisecond}.xlsx');
}
