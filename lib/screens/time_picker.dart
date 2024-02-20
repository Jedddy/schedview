import 'package:flutter/material.dart';


class TimePickerInput extends StatefulWidget {
  final int groupId;

  const TimePickerInput({super.key, required this.groupId});

  @override
  State<TimePickerInput> createState() => _TimePickerInput();
}

class _TimePickerInput extends State<TimePickerInput> {
  TimeOfDay _selectedTimeStart = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _selectedTimeEnd = const TimeOfDay(hour: 0, minute: 0);
  String _selectedDay = "M";
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Schedule"),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton(
            value: _selectedDay,
            items: const [
              DropdownMenuItem(
                value: "M",
                child: Text("Monday"),
              ),
              DropdownMenuItem(
                value: "T",
                child: Text("Tuesday"),
              ),
              DropdownMenuItem(
                value: "W",
                child: Text("Wednesday"),
              ),
              DropdownMenuItem(
                value: "TH",
                child: Text("Thursday"),
              ),
              DropdownMenuItem(
                value: "F",
                child: Text("Friday"),
              ),
              DropdownMenuItem(
                value: "S",
                child: Text("Saturday"),
              ),
              DropdownMenuItem(
                value: "SU",
                child: Text("Sunday"),
              )
            ],
            onChanged: (val) {
              setState(() {
                _selectedDay = val!;
              });
            },
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
                        final data = {
                          "groupId": widget.groupId,
                          "label": _controller.text,
                          "day": _selectedDay,
                          "timeStart": _selectedTimeStart.format(context),
                          "timeEnd": _selectedTimeEnd.format(context),
                        };

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

String _formatTimeOfDay(TimeOfDay time) {
  final hours = time.hour.toString().padLeft(2, '0');
  final minutes = time.minute.toString().padLeft(2, '0');
  return '$hours:$minutes';
}
