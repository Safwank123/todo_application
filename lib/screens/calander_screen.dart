import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/providers/task_provider.dart';


class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;
    final events = {
      for (var task in tasks)
        task.deadline: [task]
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: TableCalendar(
        firstDay: DateTime.utc(2010),
        lastDay: DateTime.utc(2030),
        focusedDay: DateTime.now(),
        eventLoader: (day) => events[day] ?? [],
        calendarStyle: const CalendarStyle(
          markersAutoAligned: false,
          markerDecoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
      ),
    );
  }
}