import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  final FlutterLocalNotificationsPlugin fltrNotification =
      FlutterLocalNotificationsPlugin();
  String? _selectedParam;
  String? task;
  int? val;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Initialize timezone data - this is essential
    tz_data.initializeTimeZones();

    // Get local timezone
    final String currentTimeZone = tz.local.name;

    const AndroidInitializationSettings androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iOSinitialize =
        DarwinInitializationSettings();
    const InitializationSettings initilizationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSinitialize);

    await fltrNotification.initialize(
      initilizationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        notificationSelected(details.payload);
      },
    );
  }

  Future<void> _showNotification() async {
    if (task == null || task!.isEmpty) {
      // Show error if no task is specified
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a reminder note'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    if (_selectedParam == null || val == null) {
      // Show error if time parameters aren't selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both time unit and value'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "vaccine_reminders", // Channel ID
      "Vaccine Reminders", // Channel name
      channelDescription: "Reminders for upcoming vaccines",
      importance: Importance.max,
      priority: Priority.high,
      color: Theme.of(context).primaryColor, // Using theme primary color
      enableLights: true,
      enableVibration: true,
      playSound: true,
      styleInformation: DefaultStyleInformation(true, true),
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // Create a scheduled time based on user selection
    tz.TZDateTime scheduledTime;

    if (_selectedParam == "Hour" && val != null) {
      scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(hours: val!));
    } else if (_selectedParam == "Minutes" && val != null) {
      scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(minutes: val!));
    } else {
      scheduledTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: val!));
    }

    try {
      await fltrNotification.zonedSchedule(
          1, // Notification ID
          "Vaccine Reminder",
          task,
          scheduledTime,
          generalNotificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Reminder set successfully for: ${scheduledTime.toString()}'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    } catch (e) {
      print("Error scheduling notification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set reminder: $e'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jpg',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 10),
            Text('Set Reminders'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Custom Reminder',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                  labelText: 'Reminder Note',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? Colors.white70
                        : Theme.of(context).primaryColorDark,
                  ),
                  hintText: 'Enter your reminder message',
                  prefixIcon: Icon(
                    Icons.note_add,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onChanged: (val) {
                  task = val;
                },
                cursorColor: Theme.of(context).primaryColor,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Time Unit',
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.white70
                              : Theme.of(context).primaryColorDark,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                      ),
                      value: _selectedParam,
                      items: [
                        DropdownMenuItem(
                            value: "Seconds", child: Text("Seconds")),
                        DropdownMenuItem(
                            value: "Minutes", child: Text("Minutes")),
                        DropdownMenuItem(value: "Hour", child: Text("Hour")),
                      ],
                      hint: Text("Select Unit"),
                      onChanged: (val) {
                        setState(() {
                          _selectedParam = val;
                        });
                      },
                      dropdownColor: isDarkMode
                          ? Theme.of(context).cardColor
                          : Theme.of(context).primaryColor.withOpacity(0.05),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Value',
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.white70
                              : Theme.of(context).primaryColorDark,
                        ),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2.0),
                        ),
                      ),
                      value: val,
                      items: List.generate(
                        10,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text("${index + 1}"),
                        ),
                      ),
                      hint: Text("Select Value"),
                      onChanged: (value) {
                        setState(() {
                          val = value;
                        });
                      },
                      dropdownColor: isDarkMode
                          ? Theme.of(context).cardColor
                          : Theme.of(context).primaryColor.withOpacity(0.05),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: _showNotification,
                icon: Icon(Icons.notifications_active),
                label: Text('Set Reminder', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future notificationSelected(String? payload) async {
    // Using BLoC for the dialog
    final isDarkMode = context.read<ThemeBloc>().state.isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Theme.of(context).cardColor : Colors.white,
        title: Text(
          'Notification',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        content: Text(
          "Reminder: ${payload ?? 'No message'}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}