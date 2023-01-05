// import 'dart:async';

// import 'package:attendance_system/core/app/colors.dart';
// import 'package:attendance_system/main.dart';
// import 'package:attendance_system/screens/calendar/calendar_screen.dart';
// import 'package:attendance_system/utils/get_events.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:table_calendar/table_calendar.dart';

// import '../../../core/development/console.dart';
// import '../../../services/local_auth.dart';

// class FingerPrintBody extends StatefulWidget {
//   const FingerPrintBody({super.key});

//   @override
//   State<FingerPrintBody> createState() => _FingerPrintBodyState();
// }

// class _FingerPrintBodyState extends State<FingerPrintBody> with SingleTickerProviderStateMixin {
 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
     
//       appBar: AppBar(
//         title: const Text(
//           MyApp.title,
//           style: TextStyle(
//             fontSize: 20.0,
//           ),
//         ),
//         // actions: [
//         //   ValueListenableBuilder(
//         //     valueListenable: checkInOrOutBox.listenable(),
//         //     builder: (context, box, _) {
//         //       return Row(
//         //         children: [
//         //           Text(
//         //             box.get("isCheckIn") == true ? "Clock Out" : "Clock In",
//         //             style: const TextStyle(
//         //               color: Colors.black,
//         //             ),
//         //           ),
//         //           Switch.adaptive(
//         //             value: box.get("isCheckIn") == true,
//         //             activeColor: AColors.kPrimaryColor,
//         //             onChanged: (val) async {
//         //               final isAuthenticated = await LocalAuth.authenticate();

//         //               if (isAuthenticated) {
//         //                 final today = DateTime.now();
//         //                 final dateTime = DateTime.utc(today.year, today.month, today.day);
//         //                 List data = attendanceModelBox?.get(dateTime.toString()) ?? [];

//         //                 if (checkInOrOutBox.get("isCheckIn") == true) {
//         //                   _timer?.cancel();
//         //                   checkInOrOutBox.put("isCheckIn", false);
//         //                   if (attendanceModelBox?.containsKey(dateTime.toString()) == true) {
//         //                     List newData = data.map((val) {
//         //                       if (val["endTime"] == null) {
//         //                         val["endTime"] = today;
//         //                       }

//         //                       return val;
//         //                     }).toList();

//         //                     attendanceModelBox?.put(dateTime.toString(), newData);
//         //                   }
//         //                 } else {
//         //                   checkInOrOutBox.put("isCheckIn", true);

//         //                   if (attendanceModelBox?.containsKey(dateTime.toString()) == true) {
//         //                     List data = attendanceModelBox?.get(dateTime.toString());
//         //                     data.removeWhere((element) => element["endTime"] == null);

//         //                     data.add(
//         //                       {
//         //                         "startTime": today,
//         //                         "endTime": null,
//         //                       },
//         //                     );
//         //                     attendanceModelBox?.put(dateTime.toString(), data);
//         //                   } else {
//         //                     attendanceModelBox?.put(
//         //                       dateTime.toString(),
//         //                       [
//         //                         {
//         //                           "startTime": today,
//         //                           "endTime": null,
//         //                         },
//         //                       ],
//         //                     );
//         //                   }
//         //                 }
//         //                 getTime();
//         //               }
//         //             },
//         //           ),
//         //         ],
//         //       );
//         //     },
//         //   ),
//         // ],
//       ),
//       body: 
//     );
//   }
// }
