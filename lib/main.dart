import 'package:flutter/material.dart';
import 'package:sched_view/screens/settings.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("settings");

  runApp(
    MaterialApp(
      title: "SchedView",
      routes: {
        "/": (context) => const SafeArea(child: HomePage()),
        "/settings": (context) => const SafeArea(child: SettingsPage()),
      },
    ),
  );
}
