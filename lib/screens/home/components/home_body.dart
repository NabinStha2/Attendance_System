import 'dart:async';

import 'package:attendance_system/core/development/console.dart';
import 'package:attendance_system/provider/theme_provider.dart';
import 'package:attendance_system/utils/get_time.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/app/colors.dart';
import '../../../core/app/states.dart';
import '../../../services/local_auth.dart';
import '../../../utils/datagrid.dart';
import '../../../utils/get_events.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  var prevDateUtc;
  @override
  void initState() {
    super.initState();
    checkInOrOutBox = Hive.box("checkInOrOutBox");
    DateTime prevDate = DateTime.now().subtract(const Duration(days: 1));
    prevDateUtc = DateTime.utc(prevDate.year, prevDate.month, prevDate.day);

    if (checkInOrOutBox?.get("isCheckIn") == null) {
      checkInOrOutBox?.put("isCheckIn", false);
    }
    if (checkInOrOutBox?.get("isCheckIn") == true) {
      if (attendanceModelBox?.containsKey(prevDateUtc.toString()) ?? false) {
        consolelog(attendanceModelBox?.get(prevDateUtc.toString()));
        if (List.of(attendanceModelBox?.get(prevDateUtc.toString()))
                .reversed
                .toList()[0]["endTime"] ==
            null) {
          List data = attendanceModelBox?.get(prevDateUtc.toString());
          data.removeWhere((element) => element["endTime"] == null);
          if (data.isEmpty) {
            attendanceModelBox?.delete(prevDateUtc.toString());
          } else {
            attendanceModelBox?.put(prevDateUtc.toString(), data);
          }
          timer?.cancel();
          checkInOrOutBox?.put("isCheckIn", false);
        }
      }
    }

    initializeDateFormatting('ne', null);
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween(begin: 0.2, end: 1.0).animate(animationController);

    animationController.addListener(() {
      // consolelog(animation.value);
      if (animationController.isCompleted) {
        animationController.reverse();
      } else if (animationController.isDismissed) {
        animationController.forward();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 44.0,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, MMM d, y').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder(
              valueListenable: lastCheckInTime,
              builder: (context, value, child) {
                return value != null
                    ? ValueListenableBuilder(
                        valueListenable: duration,
                        builder: (context, _, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Ongoing Working Time: ",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                DateTime.now()
                                    .difference(value)
                                    .toString()
                                    .split(".")[0],
                                style: TextStyle(
                                  color: Provider.of<ThemeProvider>(context,
                                              listen: false)
                                          .isDarkTheme
                                      ? const Color(0xff779EE5)
                                      : AColors.kPrimaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Container();
              },
            ),
            const SizedBox(height: 30.0),
            ValueListenableBuilder<Box>(
                valueListenable: checkInOrOutBox?.listenable() ??
                    ValueListenable as ValueListenable<Box>,
                builder: (context, value, _) {
                  // log("value :: ${value.get("isCheckIn")}");
                  return GestureDetector(
                    onTap: () async {
                      final today = DateTime.now();
                      final dateTime =
                          DateTime.utc(today.year, today.month, today.day);

                      if (attendanceModelBox
                                  ?.containsKey(dateTime.toString()) ==
                              false ||
                          (attendanceModelBox
                                      ?.containsKey(dateTime.toString()) ==
                                  true &&
                              attendanceModelBox?.get(dateTime.toString())[0]
                                      ["isPaid"] ==
                                  null)) {
                        final isAuthenticated = await LocalAuth.authenticate();

                        if (isAuthenticated) {
                          List data =
                              attendanceModelBox?.get(dateTime.toString()) ??
                                  [];

                          if (checkInOrOutBox?.get("isCheckIn") == true) {
                            timer?.cancel();
                            checkInOrOutBox?.put("isCheckIn", false);
                            if (attendanceModelBox
                                    ?.containsKey(dateTime.toString()) ==
                                true) {
                              List newData = data.map((val) {
                                if (val["endTime"] == null) {
                                  val["endTime"] = today;
                                  val["isPaid"] = null;
                                }
                                return val;
                              }).toList();
                              attendanceModelBox?.put(
                                  dateTime.toString(), newData);
                            }
                          } else {
                            checkInOrOutBox?.put("isCheckIn", true);

                            if (attendanceModelBox
                                    ?.containsKey(dateTime.toString()) ==
                                true) {
                              List data =
                                  attendanceModelBox?.get(dateTime.toString());
                              data.removeWhere(
                                  (element) => element["endTime"] == null);

                              data.add(
                                {
                                  "date": dateTime,
                                  "startTime": today,
                                  "endTime": null,
                                },
                              );
                              attendanceModelBox?.put(
                                  dateTime.toString(), data);
                            } else {
                              attendanceModelBox?.put(
                                dateTime.toString(),
                                [
                                  {
                                    "date": dateTime,
                                    "startTime": today,
                                    "endTime": null,
                                  },
                                ],
                              );
                            }
                          }
                          GetTime().getTimeData();
                          selectedEvents?.value =
                              Events.getEventsForDay(dateTime);
                          attendanceDataSource =
                              AttendanceDataSource(data: selectedEvents?.value);
                        }
                      }
                    },
                    child: Container(
                      height: 250,
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(1.0 - animation.value),
                        shape: BoxShape.circle,
                        boxShadow: value.get("isCheckIn") == true
                            ? [
                                BoxShadow(
                                  blurRadius: animation.value * 20,
                                  color: const Color(0xff779EE5).withOpacity(
                                      1.0 - (animation.value * 0.3)),
                                  spreadRadius: 0,
                                ),
                                BoxShadow(
                                  blurRadius: animation.value * 20,
                                  color: const Color(0xffD44358).withOpacity(
                                      1.0 - (animation.value * 0.3)),
                                  spreadRadius: 0,
                                )
                              ]
                            : [],
                      ),
                      child: Image.asset(
                        value.get("isCheckIn") == false
                            ? "assets/images/clock_in_scan.png"
                            : "assets/images/clock_out_scan.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 44.0,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ValueListenableBuilder(
                      valueListenable: attendanceModelBox!.listenable(),
                      builder: (context, value, _) => Text(
                        attendanceModelBox?.containsKey(
                                        focusedDateUTC.toString()) ==
                                    true &&
                                List.from(attendanceModelBox
                                            ?.get(focusedDateUTC.toString()))
                                        .reversed
                                        .toList()[0]["isPaid"] ==
                                    null
                            ? DateFormat.Hm().format(List.from(
                                    attendanceModelBox
                                            ?.get(focusedDateUTC.toString()) ??
                                        DateTime.now())
                                .reversed
                                .toList()[0]["startTime"])
                            : "--:--",
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "Clock in",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 44.0,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ValueListenableBuilder(
                      valueListenable: attendanceModelBox!.listenable(),
                      builder: (context, box, _) => Text(
                        checkInOrOutBox?.get("isCheckIn") == false &&
                                attendanceModelBox?.containsKey(
                                        focusedDateUTC.toString()) ==
                                    true &&
                                attendanceModelBox
                                        ?.get(focusedDateUTC.toString())
                                        .reversed
                                        .toList()[0]["isPaid"] ==
                                    null
                            ? DateFormat.Hm()
                                .format(List.from(attendanceModelBox
                                            ?.get(focusedDateUTC.toString()))
                                        .reversed
                                        .toList()[0]["endTime"] ??
                                    DateTime.now())
                                .toString()
                            : "--:--",
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "Clock out",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outlined,
                      size: 44.0,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ValueListenableBuilder(
                        valueListenable: attendanceModelBox!.listenable(),
                        builder: (context, box, _) {
                          if (attendanceModelBox?.containsKey(
                                      focusedDateUTC.toString()) ==
                                  true &&
                              List.from(attendanceModelBox
                                          ?.get(focusedDateUTC.toString()))
                                      .reversed
                                      .toList()[0]["isPaid"] ==
                                  null) {
                            dynamic endTime = List.from(attendanceModelBox
                                    ?.get(focusedDateUTC.toString()))
                                .reversed
                                .toList()[0]["endTime"];
                            dynamic startTime = List.from(attendanceModelBox
                                    ?.get(focusedDateUTC.toString()))
                                .reversed
                                .toList()[0]["startTime"];
                            return Text(
                              checkInOrOutBox?.get("isCheckIn") == false &&
                                      attendanceModelBox?.containsKey(
                                              focusedDateUTC.toString()) ==
                                          true
                                  ? "${endTime.difference(startTime).inHours.toString().padLeft(2, "0")}:${endTime.difference(startTime).inMinutes.remainder(60).toString().padLeft(2, "0")}"
                                  : "--:--",
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }
                          return const Text(
                            "--:--",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                    Text(
                      "Working Hrs",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
