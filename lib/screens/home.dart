import 'package:sched_view/models/group.dart';
import 'package:sched_view/screens/schedule.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late List<Group> _groups = [];
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    Future.microtask(() async {
      _groups = await getGroups();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String?> showModal()  {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Group name"),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: "Enter group name"),
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: submit,
            child: const Text("Submit")
          ),
        ]
      )
    );
  }

  void submit() {
    Navigator.of(context).pop(controller.text);

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedules"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: _groups.map((group) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Schedule())
              );
            },
            onLongPress: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Delete ${group.name}?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      deleteGroup(group.id);
                      _groups = await getGroups();
                      setState(() {});
                    },
                    child: const Text("OK")
                  )
                ],
              )
            ),
            title: Text(group.name),
          );
        }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showModal();

          if (name == null || name.isEmpty) return;

          insertGroup(name);
          _groups = await getGroups();

          setState(() {});
        },
        tooltip: "Add Schedule Group",
        child: const Icon(Icons.add),
      ),
    );
  }
}