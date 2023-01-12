import 'package:attendance_system/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../core/app/colors.dart';
import '../core/app/states.dart';
import '../core/development/console.dart';
import '../utils/datagrid.dart';
import '../utils/get_events.dart';

void showEventsModalBottomSheet({
  required BuildContext context,
  required DateTime start,
  DateTime? end,
}) {
  // attendanceModelBox?.delete(focusedDateUTC.toString());
  showModalBottomSheet(
    isDismissible: true,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(10.0),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      maxChildSize: 0.7,
      initialChildSize: 0.4,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ValueListenableBuilder<List<dynamic>>(
                  valueListenable: selectedEvents!,
                  builder: (context, value, _) {
                    consolelog(value);
                    // consolelog("attendanceModelBox :: ${attendanceModelBox?.get(start.toString())}");
                    return value.isNotEmpty
                        ? value.length == 1 && value[0]["isPaid"] != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 2.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  rowChoiceOptions(
                                    title: "Holiday",
                                    iconText: "Paid",
                                    isIcon: attendanceModelBox
                                            ?.containsKey(start.toString()) ==
                                        true,
                                    isPaid: attendanceModelBox?.containsKey(
                                                start.toString()) ==
                                            true &&
                                        attendanceModelBox
                                                    ?.get(start.toString())[0]
                                                ["isPaid"] ==
                                            true,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  rowChoiceOptions(
                                    title: "Leave",
                                    iconText: "Not Paid",
                                    isIcon: attendanceModelBox
                                            ?.containsKey(start.toString()) ==
                                        true,
                                    isPaid: attendanceModelBox?.containsKey(
                                                start.toString()) ==
                                            true &&
                                        attendanceModelBox
                                                    ?.get(start.toString())[0]
                                                ["isPaid"] ==
                                            false,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Container(
                                    height: 2.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "Date : ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            DateFormat('y:M:d').format(start),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600),
                                          ),
                                          end != null
                                              ? Text(
                                                  " - ${DateFormat('y:M:d').format(end)}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade600),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Total Working : ",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            value.length >= 2
                                                ? value
                                                    .reduce((value, element) {
                                                      Duration? value1;
                                                      Duration? value2;

                                                      if (value is! Duration) {
                                                        if (value["isPaid"] ==
                                                            null) {
                                                          value1 = value[
                                                                  "endTime"]
                                                              .difference(value[
                                                                  "startTime"]);
                                                        } else {
                                                          value1 =
                                                              const Duration();
                                                        }
                                                      } else {
                                                        value1 = value;
                                                      }
                                                      if (element["isPaid"] ==
                                                          null) {
                                                        value2 = element[
                                                                "endTime"]
                                                            .difference(element[
                                                                "startTime"]);
                                                      } else {
                                                        value2 =
                                                            const Duration();
                                                      }

                                                      // if (value is! Duration &&
                                                      //         value["isPaid"] == null &&
                                                      //         element["isPaid"] == null // (value["endTime"] != null && value["startTime"] != null) &&
                                                      //     // (element["startTime"] != null && element["endTime"] != null)
                                                      //     ) {
                                                      //   value1 = value["endTime"].difference(value["startTime"]);
                                                      //   value2 = element["endTime"].difference(element["startTime"]);
                                                      // } else if (value is Duration && element["isPaid"] == null
                                                      //     //  (element["endTime"] != null && element["startTime"] != null)
                                                      //     ) {
                                                      //   value1 = value;
                                                      //   value2 = element["endTime"].difference(element["startTime"]);
                                                      // }
                                                      // if (value is! Duration && value["isPaid"] != null) {
                                                      //   value1 = const Duration();
                                                      // }
                                                      // if (element["isPaid"] != null) {
                                                      //   value2 = const Duration();
                                                      // }

                                                      // log("value :: ${value.toString()}");
                                                      // log("element :: ${element.toString()}");
                                                      // log("value1 :: ${value1.toString()}");
                                                      // log("value2 :: ${value2.toString()}");

                                                      return value1! + value2!;
                                                    })
                                                    .toString()
                                                    .split(".")[0]
                                                : value[0]["endTime"]
                                                    .difference(
                                                        value[0]["startTime"])
                                                    .toString()
                                                    .split(".")[0],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade600,
                                    thickness: 0.18,
                                    height: 0,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      // consolelog(
                                      //     "date :: ${value[index]["date"]} :::: startTime : ${value[index]["startTime"]} :::: endTime : ${value[index]["endTime"]}");
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (value[index]["isPaid"] !=
                                                null) ...[
                                              Column(
                                                children: [
                                                  Text(
                                                    DateFormat.E()
                                                        .format(value[index]
                                                            ["date"])
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .isDarkTheme
                                                          ? const Color(
                                                              0xff779EE5)
                                                          : AColors
                                                              .kPrimaryColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        DateFormat.d()
                                                            .format(value[index]
                                                                ["date"])
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ] else ...[
                                              Column(
                                                children: [
                                                  Text(
                                                    DateFormat.E()
                                                        .format(value[index]
                                                            ["startTime"])
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Provider.of<
                                                                      ThemeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .isDarkTheme
                                                          ? const Color(
                                                              0xff779EE5)
                                                          : AColors
                                                              .kPrimaryColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        DateFormat.d()
                                                            .format(value[index]
                                                                ["startTime"])
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (value[index]["isPaid"] !=
                                                null) ...[
                                              Flexible(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    rowChoiceOptions(
                                                      title: "Holiday",
                                                      iconText: "Paid",
                                                      isIcon: attendanceModelBox
                                                              ?.containsKey(value[
                                                                          index]
                                                                      ["date"]
                                                                  .toString()) ==
                                                          true,
                                                      isPaid: attendanceModelBox
                                                                  ?.containsKey(
                                                                      value[index]
                                                                              [
                                                                              "date"]
                                                                          .toString()) ==
                                                              true &&
                                                          attendanceModelBox?.get(
                                                                      value[index]
                                                                              [
                                                                              "date"]
                                                                          .toString())[
                                                                  0]["isPaid"] ==
                                                              true,
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    rowChoiceOptions(
                                                      title: "Leave",
                                                      iconText: "Not Paid",
                                                      isIcon: attendanceModelBox
                                                              ?.containsKey(value[
                                                                          index]
                                                                      ["date"]
                                                                  .toString()) ==
                                                          true,
                                                      isPaid: attendanceModelBox
                                                                  ?.containsKey(
                                                                      value[index]
                                                                              [
                                                                              "date"]
                                                                          .toString()) ==
                                                              true &&
                                                          attendanceModelBox?.get(
                                                                      value[index]
                                                                              [
                                                                              "date"]
                                                                          .toString())[
                                                                  0]["isPaid"] ==
                                                              false,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ] else ...[
                                              Flexible(
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              right: 10.0),
                                                      child: Container(
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 0.9,
                                                            color: Colors
                                                                .grey.shade500,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        10),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  '${DateFormat('(hh:mm:s a').format(value[index]["startTime"])} - ${DateFormat('hh:mm:s a)').format(value[index]["endTime"])}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ),
                                                            Divider(
                                                              color: Colors.grey
                                                                  .shade600,
                                                              indent: 18,
                                                              endIndent: 25,
                                                              thickness: 0.2,
                                                              height: 0,
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0,
                                                                    vertical:
                                                                        10.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Flexible(
                                                                      child:
                                                                          Text(
                                                                        "Working Time : ",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          Text(
                                                                        value[index]["endTime"]
                                                                            .difference(value[index]["startTime"])
                                                                            .toString()
                                                                            .split(".")[0],
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600,
                                                                        ),
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          // consolelog("dateTime :: ${value[index]["date"]}");
                                                          showDialog(
                                                              barrierDismissible:
                                                                  false,
                                                              barrierColor: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.7),
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Dialog(
                                                                  elevation: 0,
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    constraints: const BoxConstraints(
                                                                        maxHeight:
                                                                            200,
                                                                        minHeight:
                                                                            150),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          "Delete Attendance",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                17.0,
                                                                            fontFamily:
                                                                                GoogleFonts.poppins().fontFamily,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                          "Are you sure you want to delete the attendance?",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            fontFamily:
                                                                                GoogleFonts.poppins().fontFamily,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                final dateTime = value[index]["date"];
                                                                                attendanceModelBox?.toMap().entries.forEach((e) {
                                                                                  if (e.key == dateTime.toString()) {
                                                                                    // consolelog(e.value);
                                                                                    List filteredData = List.of(e.value).where((element) => element["startTime"] != value[index]["startTime"]).toList();
                                                                                    // consolelog(filteredData);
                                                                                    if (filteredData.isNotEmpty) {
                                                                                      attendanceModelBox?.put(e.key, filteredData);
                                                                                    } else {
                                                                                      attendanceModelBox?.delete(e.key);
                                                                                    }
                                                                                    if (rangeSelectionMode == RangeSelectionMode.toggledOn) {
                                                                                      if (end != null) {
                                                                                        selectedEvents?.value = Events.getEventsForRange(start, end);
                                                                                      }
                                                                                    } else {
                                                                                      selectedEvents?.value = Events.getEventsForDay(start);
                                                                                    }
                                                                                  }
                                                                                  // consolelog(attendanceModelBox?.get(e.key));
                                                                                });
                                                                                attendanceDataSource = AttendanceDataSource(data: selectedEvents?.value);

                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text(
                                                                                "Yes",
                                                                                style: TextStyle(
                                                                                  fontSize: 17.0,
                                                                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text(
                                                                                "No",
                                                                                style: TextStyle(
                                                                                  fontSize: 17.0,
                                                                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                        child: Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Colors.red,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Center(
                                                            child: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                              size: 18.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                        : rangeSelectionMode == RangeSelectionMode.toggledOff &&
                                focusedDateUTC == start &&
                                checkInOrOutBox?.get("isCheckIn") == false
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 2.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(3.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  rowChoiceOptions(
                                    title: "Holiday",
                                    iconText: "Paid",
                                    isIcon: attendanceModelBox
                                            ?.containsKey(start.toString()) ==
                                        true,
                                    isPaid: attendanceModelBox?.containsKey(
                                                start.toString()) ==
                                            true &&
                                        attendanceModelBox
                                                    ?.get(start.toString())[0]
                                                ["isPaid"] ==
                                            true,
                                    onTap: () {
                                      if (attendanceModelBox
                                              ?.containsKey(start.toString()) ==
                                          false) {
                                        attendanceModelBox?.put(
                                          start.toString(),
                                          [
                                            {
                                              "date": start,
                                              "startTime": null,
                                              "endTime": null,
                                              "isPaid": true,
                                            },
                                          ],
                                        );
                                        selectedEvents?.value =
                                            Events.getEventsForDay(start);
                                      }
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  rowChoiceOptions(
                                      title: "Leave",
                                      iconText: "Not Paid",
                                      isIcon: attendanceModelBox
                                              ?.containsKey(start.toString()) ==
                                          true,
                                      isPaid: attendanceModelBox?.containsKey(
                                                  start.toString()) ==
                                              true &&
                                          attendanceModelBox
                                                      ?.get(start.toString())[0]
                                                  ["isPaid"] ==
                                              false,
                                      onTap: () {
                                        if (attendanceModelBox?.containsKey(
                                                start.toString()) ==
                                            false) {
                                          attendanceModelBox?.put(
                                            start.toString(),
                                            [
                                              {
                                                "date": start,
                                                "startTime": null,
                                                "endTime": null,
                                                "isPaid": false,
                                              },
                                            ],
                                          );
                                          selectedEvents?.value =
                                              Events.getEventsForDay(start);
                                        }
                                      }),
                                ],
                              )
                            : Text(
                                "No Attendance!",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                ),
                              );
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget rowChoiceOptions({
  String? title,
  String? iconText,
  Function()? onTap,
  bool? isIcon = false,
  bool? isPaid = false,
}) {
  // attendanceModelBox?.delete(focusedDateUTC.toString());
  return ValueListenableBuilder(
    valueListenable: attendanceModelBox!.listenable(),
    builder: (context, value, _) => Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.9,
                color: Colors.grey.shade500,
              ),
              borderRadius: BorderRadius.circular(7.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title ?? "",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(width: 0.6, color: Colors.grey.shade500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: onTap,
                  child: isIcon ?? false
                      ? isPaid ?? false
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 20.0,
                            )
                          : const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 20.0,
                            )
                      : Text(
                          iconText ?? "",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
