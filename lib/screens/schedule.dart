import 'package:flutter/material.dart';

import 'package:sched_view/models/schedule.dart' as sched_model;
import 'package:sched_view/screens/add_schedule.dart';
import 'package:sched_view/utils.dart';

class Schedule extends StatefulWidget {
  final int groupId;
  final String groupName;

  const Schedule({super.key, required this.groupId, required this.groupName});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  final List<String> _days = ["M", "T", "W", "TH", "F", "S", "SU"];
  Map<String, List<sched_model.Schedule>>? _schedules;

  @override
  void initState() {
    _updateSchedules();

    super.initState();
  }

  void _updateSchedules() async {
    final schedules = await sched_model.getSchedules(widget.groupId);

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
                builder: (context) => AddSchedule(
                  groupId: widget.groupId,
                ),
              ),
            );

            if (!context.mounted || data == null) return;

            for (final result in data) {
              sched_model.insertSchedule(
                result["groupId"],
                result["label"],
                result["day"],
                result["timeStart"],
                result["timeEnd"],
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
  final List<sched_model.Schedule> schedule;
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
        return DataRow(
          cells: [
            DataCell(
              Text(
                "${e.timeStart} - ${e.timeEnd}",
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
              sched_model.deleteSchedule(e.id);
              widget.updater();
            },
          ),
        );
      }).toList(),
    );
  }
}
