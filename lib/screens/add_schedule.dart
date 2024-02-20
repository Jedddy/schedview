import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class AddSchedule extends StatefulWidget {
  final int groupId;

  const AddSchedule({super.key, required this.groupId});

  @override
  State<AddSchedule> createState() => _AddSchedule();
}

class _AddSchedule extends State<AddSchedule> {
  TimeOfDay _selectedTimeStart = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _selectedTimeEnd = const TimeOfDay(hour: 0, minute: 0);
  List<ValueItem> _selectedDays = [ValueItem(label: "Monday", value: "M")];
  final Map<String, String> _days = {
    "Monday": "M",
    "Tuesday": "T",
    "Wednesday": "W",
    "Thursday": "TH",
    "Friday": "F",
    "Saturday": "S",
    "Sunday": "SU",
  };
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
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
      ),
      body: Column(
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
              selectedOptions: [options[0]],
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
                controller: _controller,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Time Start: ${_selectedTimeStart.format(context)}"),
                  Text("Time End: ${_selectedTimeEnd.format(context)}"),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async => await _selectTime(context, "start"),
                    icon: const Icon(Icons.timer_rounded),
                    label: const Text("Start"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async => await _selectTime(context, "end"),
                    icon: const Icon(Icons.timer_rounded),
                    label: const Text("End"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final data = _selectedDays.map((day) {
                          return {
                            "groupId": widget.groupId,
                            "label": _controller.text,
                            "day": day.value as String,
                            "timeStart": _selectedTimeStart.format(context),
                            "timeEnd": _selectedTimeEnd.format(context),
                          };
                        });

                        Navigator.pop(context, data);
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Submit"),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
