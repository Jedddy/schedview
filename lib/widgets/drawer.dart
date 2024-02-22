import 'package:flutter/material.dart';

Widget drawer(BuildContext context) {
  return Drawer(
    surfaceTintColor: Colors.white,
    child: Column(
      children: <Widget>[
        const SizedBox(
          height: 100,
          child: DrawerHeader(
            child: Text("Schedule Viewer"),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Home"),
          onTap: () => navigateTo(context, "/"),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Settings"),
          onTap: () => navigateTo(context, "/settings"),
        ),
      ],
    ),
  );
}

void navigateTo(BuildContext context, String name) {
  if (ModalRoute.of(context)?.settings.name != name) {
    Navigator.pushReplacementNamed(context, name);
  } else {
    Navigator.pop(context);
  }
}
