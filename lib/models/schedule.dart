import 'package:flutter/material.dart';
import 'package:sched_view/database.dart';

class Schedule {
  final int id;
  final int groupId;
  final String label;
  final String day;
  final DateTime timeStart;
  final DateTime timeEnd;

  Schedule({
    required this.id,
    required this.groupId,
    required this.label,
    required this.day,
    required this.timeStart,
    required this.timeEnd,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json["id"],
      groupId: json["group_id"],
      label: json["label"],
      day: json["day"],
      timeStart: json["time_start"],
      timeEnd: json["time_end"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "groupId": groupId,
      "label": label,
      "day": day,
      "time_start": timeStart,
      "time_end": timeEnd,
    };
  }

  @override
  String toString() =>
      "Schedule(id: $id, groupId: $groupId, label: $label, day: $day, time_start: $timeStart, time_end: $timeEnd)";
}

void insertSchedule(
  String groupId,
  String label,
  String day,
  TimeOfDay timeStart,
  TimeOfDay timeEnd,
) async {
  final db = await DBHelper.getDb();

  await db.rawInsert(
      'INSERT INTO "schedule" (group_id, label, day, time_start, time_end) VALUES (?, ?, ?, ?, ?)',
      [
        groupId,
        label,
        day,
        timeStart,
        timeEnd,
      ]);
}

void deleteSchedule(int id) async {
  final db = await DBHelper.getDb();

  await db.rawDelete('DELETE FROM schedule WHERE id = ?', [id]);
}

Future<List<Schedule>> getSchedules(int groupId) async {
  final db = await DBHelper.getDb();

  final List<Map<String, dynamic>> result = await db.query("schedule",
      where: "group_id = ?",
      orderBy: "time_start",
      groupBy: "day",
      whereArgs: [groupId]);

  return result.map((schedule) {
    return Schedule.fromJson(schedule);
  }).toList();
}
