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
  final TextEditingController _controller = TextEditingController();
  final Map<int, Group> _selected = {};
  bool _showDelete = false;

  @override
  void initState() {
    _updateGroups();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
          controller: _controller,
        ),
        actions: [
          TextButton(onPressed: submit, child: const Text("Submit")),
        ],
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(_controller.text);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Schedule Viewer",
          style: TextStyle(color: Colors.white),
        ),
        actions: _showDelete
            ? <Widget>[
                IconButton(
                  onPressed: () {
                    deleteDialog(
                      context,
                      _selected.entries.map((e) => e.value.name).join(", "),
                      () {
                        for (final group in _selected.values) {
                          deleteGroup(group.id);
                        }

                        _updateGroups();
                        _showDelete = false;
                        _selected.clear();
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )
              ]
            : null,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView(
          children: _groups.map((group) {
            return ListTile(
              onTap: () {
                if (_showDelete) {
                  if (_selected.containsKey(group.id)) {
                    _selected.remove(group.id);

                    if (_selected.isEmpty) _showDelete = false;
                  } else {
                    _selected[group.id] = group;
                  }

                  setState(() {});
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Schedule(groupId: group.id, groupName: group.name),
                    ),
                  );
                }
              },
              onLongPress: () {
                setState(() {
                  _selected[group.id] = group;
                  _showDelete = true;
                });
              },
              title: Text(group.name),
              tileColor: _selected.containsKey(group.id) ? Colors.grey.shade400 : null,
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
