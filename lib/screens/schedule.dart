import 'package:flutter/material.dart';

import 'package:sched_view/models/schedule.dart' as models;
import 'package:sched_view/screens/time_picker.dart';

// import 'package:sched_view/models/schedule.dart' as models;

// class ScheduleData extends StatelessWidget {
//   final List<models.Schedule> schedules;

//   const ScheduleData({super.key, this.schedules});
// }

class Schedule extends StatefulWidget {
  final int groupId;
  final String groupName;

  const Schedule({super.key, required this.groupId, required this.groupName});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  late Map<String, List<models.Schedule>> _schedules;

  @override
  void initState() {
    Future.microtask(() async {
      final schedules = await models.getSchedules(widget.groupId);

      setState(() {
        _schedules = schedules;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName),
          bottom: const TabBar(tabs: [
            Tab(text: "M"),
            Tab(text: "T"),
            Tab(text: "W"),
            Tab(text: "TH"),
            Tab(text: "F"),
            Tab(text: "S"),
            Tab(text: "SU"),
          ]),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.ice_skating),
            Icon(Icons.ice_skating),
            Icon(Icons.ice_skating),
            Icon(Icons.ice_skating),
            Icon(Icons.ice_skating),
            Icon(Icons.ice_skating),
            Icon(Icons.ice_skating),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimePickerInput(
                    groupId: widget.groupId,
                  ),
                ));
          },
          tooltip: "Add Schedule",
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
