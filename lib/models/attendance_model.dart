import 'package:hive/hive.dart';
part 'attendance_model.g.dart';

@HiveType(typeId: 0)
class AttendanceModel extends HiveObject {
  @HiveField(0)
  DateTime? date;
  @HiveField(1)
  DateTime? startTime;
  @HiveField(2)
  DateTime? endTime;

  AttendanceModel({
    this.date,
    this.startTime,
    this.endTime,
  });
}
