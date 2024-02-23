import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AddSchedulePage extends StatefulWidget {
  final int groupId;

  const AddSchedulePage({super.key, required this.groupId});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePage();
}

class _AddSchedulePage extends State<AddSchedulePage> {
  TimeOfDay _selectedTimeStart = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _selectedTimeEnd = const TimeOfDay(hour: 0, minute: 0);
  List<ValueItem> _selectedDays = [];
  final Map<String, String> _days = {
    "Monday": "M",
    "Tuesday": "T",
    "Wednesday": "W",
    "Thursday": "TH",
    "Friday": "F",
    "Saturday": "S",
    "Sunday": "SU",
  };
  final TextEditingController _controllerLabel = TextEditingController();
  final TextEditingController _controllerNote = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _selectTime(BuildContext context, String time) async {
    TimeOfDay t;

    if (time == "start") {
      t = _selectedTimeStart;
    } else {
      t = _selectedTimeEnd;
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: t,
    );

    if (picked != null && picked != t) {
      setState(() {
        if (time == "start") {
          _selectedTimeStart = picked;
        } else {
          _selectedTimeEnd = picked;
        }
      });
    }
  }

  @override
  dispose() {
    _controllerLabel.dispose();
    _controllerNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final options = _days.entries.map((e) {
      return ValueItem(label: e.key, value: e.value);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Schedule"),
        actions: [
          IconButton(
            onPressed: () async {
              if (_selectedDays.isEmpty) {
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Incomplete Input"),
                    content: const Text("Please select at least one day."),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              }

              if (_formKey.currentState!.validate()) {
                final data = _selectedDays.map((day) {
                  return {
                    "groupId": widget.groupId,
                    "label": _controllerLabel.text,
                    "day": day.value as String,
                    "timeStart": _formatMilitary(_selectedTimeStart),
                    "timeEnd": _formatMilitary(_selectedTimeEnd),
                    "note": _controllerNote.text,
                  };
                });

                Navigator.pop(context, data);
              }
            },
            icon: const Icon(
              Icons.check,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MultiSelectDropDown(
                hint: "Select Days",
                dropdownHeight: 335,
                onOptionSelected: (e) {
                  setState(() {
                    _selectedDays = e;
                  });
                },
                options: options,
                selectedOptionIcon: const Icon(Icons.check_circle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Schedule Label"),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Label is empty.";
                    }
                    return null;
                  },
                  controller: _controllerLabel,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Time"),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () async =>
                            await _selectTime(context, "start"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade200,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text(
                          _selectedTimeStart.format(context),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      const Icon(Icons.arrow_right),
                      TextButton(
                        onPressed: () async =>
                            await _selectTime(context, "end"),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade200,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: Text(
                          _selectedTimeEnd.format(context),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12.0),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 390,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Type something",
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    label: const Text("Note"),
                  ),
                  maxLines: null,
                  controller: _controllerNote,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_formatMilitary(TimeOfDay time) {
  return "${time.hour}:${time.minute}";
}
