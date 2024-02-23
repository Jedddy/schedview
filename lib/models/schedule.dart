import 'package:sched_view/database.dart';

class Schedule {
  final int id;
  final int groupId;
  final String label;
  final String day;
  final String timeStart;
  final String timeEnd;
  final String note;

  Schedule({
    required this.id,
    required this.groupId,
    required this.label,
    required this.day,
    required this.timeStart,
    required this.timeEnd,
    required this.note,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json["id"],
      groupId: json["group_id"],
      label: json["label"],
      day: json["day"],
      timeStart: json["time_start"],
      timeEnd: json["time_end"],
      note: json["note"],
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
  String toString() => """Schedule(
        id: $id,
        groupId: $groupId,
        label: $label,
        day: $day,
        time_start: $timeStart,
        time_end: $timeEnd,
        note: $note,
      )""";
}

void insertSchedule(
  int groupId,
  String label,
  String day,
  String timeStart,
  String timeEnd,
  String note,
) async {
  final db = await DBHelper.getDb();

  await db.rawInsert(
    """
      INSERT INTO schedule (
        group_id,
        label,
        day,
        time_start,
        time_end,
        note
      ) VALUES (?, ?, ?, ?, ?, ?);
    """,
    [
      groupId,
      label,
      day,
      timeStart,
      timeEnd,
      note,
    ],
  );
}

void editSchedule(
  int id,
  String label,
  String timeStart,
  String timeEnd,
  String note,
) async {
  final db = await DBHelper.getDb();

  await db.rawUpdate(
    """
      UPDATE schedule
      SET label = ?, time_start = ?, time_end = ?, note = ?
      WHERE id = ?;
    """,
    [label, timeStart, timeEnd, note, id],
  );
}

void deleteSchedule(int id) async {
  final db = await DBHelper.getDb();

  await db.rawDelete('DELETE FROM schedule WHERE id = ?', [id]);
}

Future<Map<String, List<Schedule>>> getSchedules(int groupId) async {
  final db = await DBHelper.getDb();

  final List<Map<String, dynamic>> result = await db.rawQuery(
    "SELECT * FROM schedule WHERE group_id = ? ORDER BY TIME(time_start);",
    [groupId],
  );

  Map<String, List<Schedule>> groups = {
    "M": [],
    "T": [],
    "W": [],
    "TH": [],
    "F": [],
    "S": [],
    "SU": [],
  };

  for (Map<String, dynamic> element in result) {
    groups[element["day"]]!.add(Schedule.fromJson(element));
  }

  return groups;
}
