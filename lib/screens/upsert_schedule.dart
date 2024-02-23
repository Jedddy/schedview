import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class UpsertSchedulePage extends StatefulWidget {
  final int groupId;
  final bool isEditing;

  final int? id;
  final String? label;
  final String? day;
  final String? timeStart;
  final String? timeEnd;
  final String? note;

  const UpsertSchedulePage({
    super.key,
    required this.groupId,
    this.isEditing = false,
    this.id,
    this.label,
    this.day,
    this.timeStart,
    this.timeEnd,
    this.note,
  });

  @override
  State<UpsertSchedulePage> createState() => _UpsertSchedulePage();
}

class _UpsertSchedulePage extends State<UpsertSchedulePage> {
  late TimeOfDay _selectedTimeStart;
  late TimeOfDay _selectedTimeEnd;
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
  void initState() {
    if (widget.isEditing) {
      final [startHr, startMin] = widget.timeStart!.split(":");
      final [endHr, endMin] = widget.timeEnd!.split(":");

      _selectedTimeStart = TimeOfDay(
        hour: int.parse(startHr),
        minute: int.parse(startMin),
      );
      _selectedTimeEnd = TimeOfDay(
        hour: int.parse(endHr),
        minute: int.parse(endMin),
      );

      _controllerLabel.text = widget.label!;
      _controllerNote.text = widget.note!;
    } else {
      _selectedTimeStart = const TimeOfDay(hour: 0, minute: 0);
      _selectedTimeEnd = const TimeOfDay(hour: 0, minute: 0);
    }

    super.initState();
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
              if (_selectedDays.isEmpty && !widget.isEditing) {
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
                if (!widget.isEditing) {
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
                } else {
                  final data = {
                    "id": widget.id,
                    "label": _controllerLabel.text,
                    "timeStart": _formatMilitary(_selectedTimeStart),
                    "timeEnd": _formatMilitary(_selectedTimeEnd),
                    "note": _controllerNote.text,
                  };

                  Navigator.pop(context, data);
                }
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
              child: widget.isEditing
                  ? Text(
                      widget.day!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : MultiSelectDropDown(
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
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
