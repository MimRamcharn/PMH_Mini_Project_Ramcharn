import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'routes.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);
  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: TableCalendar(
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2022, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        onDaySelected: (date, events) {
          setState(() {
            _selectedDate = date;
          });
          Navigator.pushNamed(context, Routes.tasks, arguments: _selectedDate);
          Navigator.pushNamed(context, Routes.events, arguments: _selectedDate);
        },
      ),
    );
  }
}
