import 'package:attendance_system/provider/theme_provider.dart';
import 'package:attendance_system/widgets/show_events_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:attendance_system/core/app/colors.dart';

import '../../core/app/states.dart';
import '../../utils/get_events.dart';
import '../../utils/get_time.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime focusedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime? selectedDay;
  DateTime? rangeStart;
  DateTime? rangeEnd;

  @override
  void initState() {
    super.initState();

    selectedDay = focusedDay;

    selectedDateUTC = DateTime.utc(selectedDay!.year, selectedDay!.month, selectedDay!.day);
    focusedDateUTC = DateTime.utc(focusedDay.year, focusedDay.month, focusedDay.day);
    selectedEvents = ValueNotifier(Events.getEventsForDay(selectedDateUTC ?? focusedDateUTC!));
    focusedDateUTC = DateTime.utc(focusedDay.year, focusedDay.month, focusedDay.day);
    GetTime().getTimeData();
  }

  @override
  void dispose() {
    selectedEvents?.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text("Range Toggle ${rangeSelectionMode == RangeSelectionMode.toggledOn ? "on" : "off"}"),
                Switch.adaptive(
                  value: rangeSelectionMode == RangeSelectionMode.toggledOn,
                  activeColor: AColors.kPrimaryColor,
                  onChanged: ((value) {
                    setState(() {
                      rangeSelectionMode =
                          rangeSelectionMode == RangeSelectionMode.toggledOn ? RangeSelectionMode.toggledOff : RangeSelectionMode.toggledOn;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<ThemeProvider>(
              builder: (context, _, child) => TableCalendar(
                // locale: 'ne',
                rowHeight: 60,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: focusedDay,
                headerVisible: true,
                daysOfWeekVisible: true,
                shouldFillViewport: false,
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                  CalendarFormat.week: 'Week',
                },
                calendarFormat: calendarFormat,
                onFormatChanged: (format) {
                  if (calendarFormat != format) {
                    setState(() {
                      calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  focusedDay = focusedDay;
                },
                headerStyle: HeaderStyle(
                  titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
                  decoration: BoxDecoration(
                    color: _.isDarkTheme ? const Color(0xff779EE5) : AColors.kPrimaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: _.isDarkTheme ? const Color(0xff779EE5) : AColors.kPrimaryColor,
                    fontSize: 16.0,
                  ),
                  formatButtonDecoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  titleCentered: false,
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 28,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                weekendDays: const [DateTime.saturday],
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                daysOfWeekHeight: 20.0,
                calendarStyle: CalendarStyle(
                  weekendTextStyle: const TextStyle(color: Colors.red),
                  todayDecoration: const BoxDecoration(
                    color: AColors.kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xff779EE5),
                    shape: BoxShape.circle,
                  ),
                  tableBorder: TableBorder(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    left: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    right: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  markerSize: 5.0,
                  markersMaxCount: 3,
                  cellMargin: const EdgeInsets.all(8.0),
                  markerMargin: const EdgeInsets.only(top: 6.0, right: 1.5),
                  markerDecoration: BoxDecoration(
                    color: _.isDarkTheme ? const Color(0xff779EE5) : AColors.kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (currentSelectedDate) {
                  return (isSameDay(selectedDay, currentSelectedDate));
                },
                onDaySelected: (selectedDays, focusedDays) {
                  if (!isSameDay(selectedDay, selectedDays)) {
                    setState(() {
                      selectedDay = selectedDays;
                      focusedDay = focusedDays;
                      rangeStart = null;
                      rangeEnd = null;
                      // rangeSelectionMode = RangeSelectionMode.toggledOff;
                    });
                  }
                  selectedEvents?.value = Events.getEventsForDay(selectedDays);
                  showEventsModalBottomSheet(context: context, start: selectedDays);
                },
                eventLoader: (day) {
                  return Events.getEventsForDay(day);
                },
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    return Container(
                      padding: const EdgeInsets.only(top: 4.0),
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat.E().format(day),
                        style: TextStyle(
                          color: DateFormat.E().format(day) == "Sat" ? Colors.red : null,
                        ),
                      ),
                    );
                  },
                  // selectedBuilder: (context, date, events) => Container(
                  //     margin: const EdgeInsets.all(4.0),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(50.0)),
                  //     child: Text(
                  //       date.day.toString(),
                  //       style: const TextStyle(color: Colors.white),
                  //     )),
                  // todayBuilder: (context, date, events) => Container(
                  //   margin: const EdgeInsets.all(4.0),
                  //   alignment: Alignment.center,
                  //   decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(50.0)),
                  //   child: Text(
                  //     date.day.toString(),
                  //     style: const TextStyle(color: Colors.white),
                  //   ),
                  // ),
                ),
                rangeStartDay: rangeStart,
                rangeEndDay: rangeEnd,
                rangeSelectionMode: rangeSelectionMode,
                onRangeSelected: (start, end, focusedDays) {
                  setState(() {
                    selectedDay = null;
                    focusedDay = focusedDays;
                    rangeStart = start;
                    rangeEnd = end;
                    // rangeSelectionMode = RangeSelectionMode.toggledOn;
                  });
                  if (start != null && end != null) {
                    selectedEvents?.value = Events.getEventsForRange(start, end);
                    showEventsModalBottomSheet(
                      context: context,
                      start: start,
                      end: end,
                    );
                  } else if (start != null) {
                    selectedEvents?.value = Events.getEventsForDay(start);
                  } else if (end != null) {
                    selectedEvents?.value = Events.getEventsForDay(end);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Map<DateTime, List<Event>> events = {
//   DateTime.utc(2022, 12, 18): [
//     Event(
//       date: DateTime.now(),
//     ),
//   ],
//   DateTime.utc(2022, 12, 20): [
//     Event(
//       date: DateTime.now(),
//     ),
//     Event(
//       date: DateTime.now().add(const Duration(hours: 6)),
//     ),
//   ],
// };

// class Event {
//   final DateTime? date;
//   final DateTime? startTime;
//   final DateTime? endTime;

//   const Event({
//     this.date,
//     this.startTime,
//     this.endTime,
//   });
// }



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// import '../../core/app/colors.dart';

// List<Appointment> appointments = <Appointment>[];

// class CalendarScreen extends StatelessWidget {
//   CalendarScreen({super.key});

//   final CalendarController _controller = CalendarController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: SizedBox(
//         // height: MediaQuery.of(context).size.height * 0.8,
//         child: SfCalendar(
//           view: CalendarView.month,
//           allowedViews: const [
//             CalendarView.day,
//             CalendarView.month,
//             CalendarView.week,
//             CalendarView.schedule,
//             // CalendarView.timelineDay,
//             // CalendarView.timelineMonth,
//             // CalendarView.timelineWeek,
//             // CalendarView.timelineWorkWeek,
//             // CalendarView.workWeek,
//           ],
//           monthCellBuilder: (BuildContext buildContext, MonthCellDetails details) {
//             return Container(
//               margin: const EdgeInsets.all(10.0),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color:
//                     details.date.year == DateTime.now().year && details.date.month == DateTime.now().month && details.date.day == DateTime.now().day
//                         ? AColors.kPrimaryColor
//                         : Colors.transparent,
//               ),
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Text(details.date.day.toString(),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: details.date.year == DateTime.now().year &&
//                               details.date.month == DateTime.now().month &&
//                               details.date.day == DateTime.now().day
//                           ? Colors.white
//                           : Colors.black,
//                     )),
//               ),
//             );
//           },
//           timeSlotViewSettings: const TimeSlotViewSettings(
//             nonWorkingDays: <int>[DateTime.saturday],
//           ),
//           // onTap: (CalendarTapDetails details) {
//           //   log("details :: ${details.date}");
//           //   _getCalendarDataSource().getOccurrenceAppointment(appointments, details.date ?? DateTime.now(), '');
//           //   details.targetElement == CalendarElement.calendarCell || details.targetElement == CalendarElement.appointment
//           //       ? showModalBottomSheet(
//           //           context: context,
//           //           isScrollControlled: true,
//           //           isDismissible: true,
//           //           elevation: 0,
//           //           enableDrag: true,
//           //           shape: const RoundedRectangleBorder(
//           //             borderRadius: BorderRadius.vertical(
//           //               top: Radius.circular(20),
//           //             ),
//           //           ),
//           //           clipBehavior: Clip.antiAliasWithSaveLayer,
//           //           builder: (_) => DraggableScrollableSheet(
//           //             initialChildSize: 0.4,
//           //             minChildSize: 0,
//           //             maxChildSize: 0.75,
//           //             expand: false,
//           //             snap: true,
//           //             snapSizes: const [0.0],
//           //             builder: (context, sc) {
//           //               return ListView.builder(
//           //                   shrinkWrap: true,
//           //                   itemCount: details.appointments?.length,
//           //                   itemBuilder: ((context, index) {
//           //                     return Column(
//           //                       children: [
//           //                         Text(details.appointments?[index].startTime.toString() ?? ""),
//           //                       ],
//           //                     );
//           //                   }));
//           //             },
//           //           ),
//           //         )
//           //       : null;
//           // },
//           // dataSource: MeetingDataSource(_getDataSource()),
//           dataSource: _getCalendarDataSource(),
//           monthViewSettings: const MonthViewSettings(
//             dayFormat: 'EEE',
//             appointmentDisplayCount: 3,
//             appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
//             showAgenda: true,
//             agendaItemHeight: 80,
//             navigationDirection: MonthNavigationDirection.horizontal,
//             agendaStyle: AgendaStyle(
//               backgroundColor: Colors.transparent,
//               // appointmentTextStyle: TextStyle(
//               //   color: Colors.white,
//               //   fontSize: 13,
//               //   fontStyle: FontStyle.italic,
//               // ),
//               dayTextStyle: TextStyle(
//                 color: Colors.black,
//                 fontSize: 13,
//                 fontStyle: FontStyle.italic,
//               ),
//               dateTextStyle: TextStyle(
//                 color: Colors.black,
//                 fontSize: 25,
//                 fontWeight: FontWeight.bold,
//                 fontStyle: FontStyle.normal,
//               ),
//             ),
//           ),
//           showDatePickerButton: true,
//           showNavigationArrow: true,
//           viewHeaderStyle: const ViewHeaderStyle(
//             dayTextStyle: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//             ),
//             dateTextStyle: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//             ),
//           ),
//           scheduleViewSettings: const ScheduleViewSettings(
//             dayHeaderSettings: DayHeaderSettings(
//               dayFormat: 'EEEE',
//               // width: 70,
//               dayTextStyle: TextStyle(
//                 fontSize: 10,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.white,
//               ),
//               dateTextStyle: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w300,
//                 color: Colors.white,
//               ),
//             ),
//             appointmentItemHeight: 80,
//             monthHeaderSettings: MonthHeaderSettings(
//                 monthFormat: 'MMMM, yyyy',
//                 height: 70,
//                 textAlign: TextAlign.left,
//                 backgroundColor: AColors.kPrimaryColor,
//                 monthTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
//             weekHeaderSettings: WeekHeaderSettings(
//               height: 40,
//               textAlign: TextAlign.left,
//             ),
//           ),
//           controller: _controller,
//           appointmentBuilder: appointmentBuilder,
//         ),
//       ),
//     );
//   }
// }

// Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails calendarAppointmentDetails) {
//   final Appointment appointment = calendarAppointmentDetails.appointments.first;
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(10),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Flexible(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6.0),
//             alignment: Alignment.centerLeft,
//             width: calendarAppointmentDetails.bounds.width,
//             height: calendarAppointmentDetails.bounds.height / 2,
//             color: AColors.kPrimaryColor,
//             child: Text(
//               '${DateFormat('(hh:mm a').format(appointment.startTime)} - ${DateFormat('hh:mm a)').format(appointment.endTime)}',
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ),
//         Flexible(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6.0),
//             width: calendarAppointmentDetails.bounds.width,
//             height: calendarAppointmentDetails.bounds.height / 2,
//             color: AColors.kPrimaryColor,
//             child: Row(
//               children: [
//                 const Flexible(
//                   child: Text(
//                     "Total Working Time : ",
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 Flexible(
//                   child: Text(
//                     appointment.endTime.difference(appointment.startTime).toString().split(".")[0],
//                     style: const TextStyle(fontSize: 14),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// class DataSource extends CalendarDataSource {
//   DataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }

// DataSource _getCalendarDataSource() {
//   appointments.addAll([
//     Appointment(
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(const Duration(hours: 2)),
//       isAllDay: false,
//       subject: 'Meeting',
//       color: AColors.kPrimaryColor,
//     ),
//     Appointment(
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(const Duration(hours: 2)),
//       isAllDay: false,
//       subject: 'Meeting',
//       color: AColors.kPrimaryColor,
//     ),
//     Appointment(
//       startTime: DateTime.now(),
//       endTime: DateTime.now().add(const Duration(hours: 2)),
//       isAllDay: false,
//       subject: 'Meeting',
//       color: AColors.kPrimaryColor,
//     ),
//   ]);

//   return DataSource(appointments);
// }

// // List<Meeting> _getDataSource() {
// //   final List<Meeting> meetings = <Meeting>[];
// //   final DateTime today = DateTime.now();
// //   final DateTime startTime = DateTime(
// //     today.year,
// //     today.month,
// //     today.day,
// //     today.hour,
// //     today.minute,
// //     today.second,
// //     today.millisecond,
// //   );
// //   final DateTime endTime = startTime.add(const Duration(
// //     hours: 2,
// //     minutes: 50,
// //   ));
// //   final Duration total = endTime.difference(startTime);
// //   consolelog("total :: $total");
// //   meetings.addAll([
// //     Meeting(
// //       'Conference',
// //       startTime,
// //       endTime,
// //       const Color(0xFF0F8644),
// //       false,
// //       total,
// //     ),
// //   ]);
// //   return meetings;
// // }

// // class MeetingDataSource extends CalendarDataSource {
// //   MeetingDataSource(List<Meeting> source) {
// //     appointments = source;
// //   }

// //   @override
// //   DateTime getStartTime(int index) {
// //     return appointments![index].from;
// //   }

// //   @override
// //   DateTime getEndTime(int index) {
// //     return appointments![index].to;
// //   }

// //   @override
// //   String getSubject(int index) {
// //     return appointments![index].eventName;
// //   }

// //   @override
// //   Color getColor(int index) {
// //     return AColors.kPrimaryColor;
// //   }

// //   @override
// //   bool isAllDay(int index) {
// //     return appointments![index].isAllDay;
// //   }

// //   Duration total(int index) {
// //     return appointments![index].total;
// //   }
// // }

// // class Meeting {
// //   Meeting(
// //     this.eventName,
// //     this.from,
// //     this.to,
// //     this.background,
// //     this.isAllDay,
// //     this.totalWorkingHours,
// //   );

// //   String eventName;
// //   DateTime from;
// //   DateTime to;
// //   Color background;
// //   bool isAllDay;
// //   Duration totalWorkingHours;
// // }