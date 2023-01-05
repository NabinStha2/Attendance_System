import '../core/app/states.dart';

class Events {
  static List<dynamic> getEventsForDay(
    DateTime day,
  ) {
    if (attendanceModelBox?.containsKey(day.toString()) == true) {
      List data = attendanceModelBox?.get(day.toString());
      if (data.isNotEmpty && data[0]["isPaid"] != null) {
        List newFilteredData = data.where((element) => element["isPaid"] != null).toList();
        return newFilteredData;
      }
      List newData = data.where((element) => element["endTime"] != null).toList();
      return newData;
    }
    return [];
  }

  static List<dynamic> getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ...getEventsForDay(d),
    ];
  }

  static List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
      (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }
}
