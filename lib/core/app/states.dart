import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

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
