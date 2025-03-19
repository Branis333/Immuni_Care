import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/schedule/schedule_bloc.dart';
import '../bloc/schedule/schedule_event.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  List<String> _timeSlots = [];

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
  }

  void _generateTimeSlots() {
    _timeSlots = [
      "09:00 AM", "10:00 AM", "11:00 AM",
      "01:00 PM", "02:00 PM", "03:00 PM",
      "04:00 PM", "07:00 PM", "08:00 PM"
    ];
  }

  void _selectDate(bool isNext) {
    setState(() {
      _selectedDate = isNext
          ? DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day)
          : DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _bookAppointment() {
    if (_selectedTime != null) {
      context.read<ScheduleBloc>().add(
        AddSchedule(title: "Doctor Appointment", dateTime: _selectedDate),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment booked for $_selectedTime on ${DateFormat('yyyy-MM-dd').format(_selectedDate)}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _selectDate(false),
                ),
                Text(DateFormat('MMMM yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _selectDate(true),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: const Text("Select Date"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/schedule.webp', height: 150),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _timeSlots.map((time) {
                      bool isSelected = time == _selectedTime;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = time),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.blue)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedTime != null ? _bookAppointment : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Book Appointment"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}