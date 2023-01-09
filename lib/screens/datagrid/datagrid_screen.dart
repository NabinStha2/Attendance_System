import 'package:attendance_system/utils/export_datagrid.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/app/states.dart';
import '../../utils/datagrid.dart';

class DataGridScreen extends StatefulWidget {
  const DataGridScreen({super.key});

  @override
  State<DataGridScreen> createState() => _DataGridScreenState();
}

class _DataGridScreenState extends State<DataGridScreen> {
  @override
  void initState() {
    super.initState();
    attendanceDataSource = AttendanceDataSource(data: selectedEvents?.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder(
        valueListenable: selectedEvents!,
        builder: (context, value, child) {
          return Column(
            children: [
              Container(
                  margin: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: attendanceDataSource.attendanceData.isNotEmpty ? exportDataGridToExcel : null,
                      child: const Center(
                        child: Text(
                          'Export to Excel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SfDataGrid(
                  key: sfDataGridKey,
                  source: attendanceDataSource,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fitByColumnName,
                  allowSorting: true,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'Date',
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                        label: Container(padding: const EdgeInsets.all(4.0), alignment: Alignment.center, child: const Text('Date'))),
                    GridColumn(
                        columnName: 'Weekday',
                        label: Container(padding: const EdgeInsets.all(4.0), alignment: Alignment.center, child: const Text('Weekday'))),
                    GridColumn(
                        columnName: 'Time',
                        columnWidthMode: ColumnWidthMode.fitByCellValue,
                        label: Container(padding: const EdgeInsets.all(4.0), alignment: Alignment.center, child: const Text('Time'))),
                    GridColumn(
                        columnName: 'Working hour',
                        label: Container(padding: const EdgeInsets.all(4.0), alignment: Alignment.center, child: const Text(' Working hour'))),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
