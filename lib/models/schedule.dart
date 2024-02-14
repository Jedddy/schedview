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
}