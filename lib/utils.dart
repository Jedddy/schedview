import 'package:flutter/material.dart';

Future<dynamic> deleteDialog(
  BuildContext context,
  String label,
  Function() cb,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Delete $label?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            cb();
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
