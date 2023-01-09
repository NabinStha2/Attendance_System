import 'package:attendance_system/core/development/console.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class EmployeeDataSource extends DataGridSource {
  List<DataGridRow> attendanceData = [];

  EmployeeDataSource({List<dynamic>? data}) {
    data?.forEach(
      (e) => attendanceData.add(DataGridRow(
        cells: [
          DataGridCell<int>(columnName: 'Day', value: e["date"].day),
          DataGridCell<String>(
              columnName: 'Weekday',
              value: DateFormat.E().format(e["date"]).toString()),
          DataGridCell<String>(
              columnName: 'Time',
              value:
                  "${DateFormat('h:mm:ss').format(e["startTime"]).toString()} - ${DateFormat('h:mm:ss').format(e["endTime"]).toString()}"),
          DataGridCell<String>(
              columnName: 'Total working',
              value: e["endTime"]
                  .difference(e["startTime"])
                  .toString()
                  .split(".")[0]),
        ],
      )),
    );
    consolelog("attendanceData :: $attendanceData");
  }

  @override
  List<DataGridRow> get rows => attendanceData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'Day' ||
                dataGridCell.columnName == 'Total working')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
