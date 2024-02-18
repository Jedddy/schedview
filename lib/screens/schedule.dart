import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: "M"),
              Tab(text: "T"),
              Tab(text: "W"),
              Tab(text: "TH"),
              Tab(text: "F"),
              Tab(text: "S"),
              Tab(text: "SU"),
            ]
          ),
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
        )
      )
    );
  }
}