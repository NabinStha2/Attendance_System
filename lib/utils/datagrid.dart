import 'package:attendance_system/core/development/console.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AttendanceDataSource extends DataGridSource {
  List<DataGridRow> attendanceData = [];

  AttendanceDataSource({List<dynamic>? data}) {
    data?.forEach(
      (e) => attendanceData.add(DataGridRow(
        cells: [
          DataGridCell<String>(
              columnName: 'Date',
              value: DateFormat("y:MM:dd").format(e["date"])),
          DataGridCell<String>(
              columnName: 'Weekday',
              value: DateFormat.EEEE().format(e["date"]).toString()),
          DataGridCell<String>(
              columnName: 'Time',
              value: e["isPaid"] == null
                  ? "${DateFormat('h:mm:ss a').format(e["startTime"]).toString()} - ${DateFormat('h:mm:ss a').format(e["endTime"]).toString()}"
                  : "-"),
          DataGridCell<String>(
              columnName: 'Working hour',
              value: e["isPaid"] == null
                  ? e["endTime"]
                      .difference(e["startTime"])
                      .toString()
                      .split(".")[0]
                  : "-"),
          DataGridCell<String>(
              columnName: 'Is Paid',
              value: e["isPaid"] == null
                  ? "Yes"
                  : e["isPaid"] == true
                      ? "Yes"
                      : "No"),
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
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
