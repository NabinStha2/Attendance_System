import 'dart:async';

import '../core/app/states.dart';
import '../core/development/console.dart';

class GetTime {
  getTimeData() {
    if (attendanceModelBox?.containsKey(focusedDateUTC.toString()) == true) {
      List data = attendanceModelBox?.get(focusedDateUTC.toString());
      var reverseData = data.reversed;
      var firstData = reverseData.first;
      if (firstData["endTime"] == null) {
        lastCheckInTime.value = firstData["startTime"];
        timer = Timer.periodic(const Duration(seconds: 1), (timers) {
          duration.value++;
        });
        consolelog("forward");
        animationController.forward();
      } else {
        consolelog("reset");
        animationController.reset();
        animationController.stop();
        lastCheckInTime.value = null;
        duration.value = 0;
      }
    }
  }
}
