import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../screens/datagrid.dart';

Box? attendanceModelBox;
Box? checkInOrOutBox;
Box? themeBox;

ValueNotifier<List<dynamic>>? selectedEvents;
ValueNotifier<DateTime?> lastCheckInTime = ValueNotifier<DateTime?>(null);
ValueNotifier<int> duration = ValueNotifier<int>(0);

late Animation animation;
late AnimationController animationController;

Timer? timer;
DateTime? focusedDateUTC;
DateTime? selectedDateUTC;
RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOff;

final GlobalKey<SfDataGridState> sfDataGridKey = GlobalKey<SfDataGridState>();
EmployeeDataSource? employeeDataSource;
