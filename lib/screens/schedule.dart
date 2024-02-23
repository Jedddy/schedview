import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sched_view/models/schedule.dart';
import 'package:sched_view/screens/add_schedule.dart';
import 'package:sched_view/utils.dart';

class SchedulePage extends StatefulWidget {
  final int groupId;
  final String groupName;

  const SchedulePage(
      {super.key, required this.groupId, required this.groupName});

  @override
  State<SchedulePage> createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> {
  final List<String> _days = ["M", "T", "W", "TH", "F", "S", "SU"];
  Map<String, List<Schedule>>? _schedules;

  @override
  void initState() {
    _updateSchedules();

    super.initState();
  }

  void _updateSchedules() async {
    final schedules = await getSchedules(widget.groupId);

    setState(() {
      _schedules = schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            widget.groupName,
            style: const TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: _days.map((day) {
              return Tab(
                text: day,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: _days.map((day) {
            return ScheduleTable(
              schedule: _schedules?[day] ?? [],
              updater: _updateSchedules,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final data = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSchedulePage(
                  groupId: widget.groupId,
                ),
              ),
            );

            if (!context.mounted || data == null) return;

            for (final result in data) {
              insertSchedule(
                result["groupId"],
                result["label"],
                result["day"],
                result["timeStart"],
                result["timeEnd"],
                result["note"],
              );
            }

            _updateSchedules();
          },
          tooltip: "Add Schedule",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ScheduleTable extends StatefulWidget {
  final List<Schedule> schedule;
  final Function() updater;

  const ScheduleTable({
    super.key,
    required this.schedule,
    required this.updater,
  });

  @override
  State<ScheduleTable> createState() => _ScheduleTable();
}

class _ScheduleTable extends State<ScheduleTable> {
  var box = Hive.box("settings");

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showBottomBorder: true,
      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      columns: const <DataColumn>[
        DataColumn(label: Text("Time")),
        DataColumn(label: Text("Label")),
      ],
      rows: widget.schedule.map((e) {
        bool setting = box.get("use24hr", defaultValue: false);
        String timeStart =
            setting ? e.timeStart : _formatLocalized(context, e.timeStart);
        String timeEnd =
            setting ? e.timeEnd : _formatLocalized(context, e.timeEnd);

        return DataRow(
          cells: [
            DataCell(
              Text(
                "$timeStart - $timeEnd",
              ),
            ),
            DataCell(
              Text(
                e.label,
              ),
            ),
          ],
          onLongPress: () => deleteDialog(
            context,
            e.label,
            () async {
              deleteSchedule(e.id);
              widget.updater();
            },
          ),
        );
      }).toList(),
    );
  }
}

_formatLocalized(BuildContext context, String time) {
  final [hour, minute] = time.split(":");
  final tod = TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));

  return tod.format(context);
}
