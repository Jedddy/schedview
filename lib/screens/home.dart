import 'package:sched_view/models/group.dart';
import 'package:sched_view/screens/schedule.dart';
import 'package:flutter/material.dart';
import 'package:sched_view/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  late List<Group> _groups = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    _updateGroups();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _updateGroups() async {
    final groups = await getGroups();

    setState(() {
      _groups = groups;
    });
  }

  Future<String?> showModal() {
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
          TextButton(onPressed: submit, child: const Text("Submit")),
        ],
      ),
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
        title: const Text(
          "Schedule Viewer",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: _groups.map((group) {
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Schedule(groupId: group.id, groupName: group.name),
                  ),
                );
              },
              onLongPress: () => deleteDialog(context, group.name, () {
                deleteGroup(group.id);
                _updateGroups();
              }),
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
          _updateGroups();
        },
        tooltip: "Add Schedule Group",
        child: const Icon(Icons.add),
      ),
    );
  }
}
