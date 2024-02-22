import 'package:flutter/material.dart';
import 'package:sched_view/widgets/drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var box = Hive.box("settings");
    var use24hr = box.get(
      "use24hr",
      defaultValue: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: drawer(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Use 24 Hour Format"),
                Switch(
                  value: use24hr,
                  onChanged: (value) {
                    setState(() {
                      box.put("use24hr", value);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
