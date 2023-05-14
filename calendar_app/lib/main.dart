import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/calendar_mainpage.dart';
import 'screens/tasks_page.dart';
import 'screens/events_page.dart';
import 'screens/add_edit_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      initialRoute: '/',
      routes: {
        '/': (context) => CalendarPage(),
        Routes.tasks: (context) => TasksPage(
            selectedDate:
                ModalRoute.of(context)!.settings.arguments as DateTime),
        Routes.events: (context) => EventsPage(
            selectedDate:
                ModalRoute.of(context)!.settings.arguments as DateTime),
        Routes.addEditTask: (context) => AddEditTaskPage(
            task: ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?),
      },
    );
  }
}

class Routes {
  static const tasks = '/tasks';
  static const events = '/events';
  static const addEditTask = '/addEditTask';
}
