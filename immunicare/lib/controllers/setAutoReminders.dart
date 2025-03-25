import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immunicare/data/child.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Reminders {
  final FlutterLocalNotificationsPlugin fltrNotification = FlutterLocalNotificationsPlugin();
  final Child child;
  
  // Constructor
  Reminders(this.child) {
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Initialize timezone data
    tz.initializeTimeZones();
    
    // Initialize notification settings
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

  Future<void> showNotification() async {
    if (child.events.isEmpty) {
      print("No events to schedule notifications for");
      return;
    }
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "vaccine_reminders", // Channel ID
      "Vaccine Reminders", // Channel name
      channelDescription: "Reminders for upcoming vaccines",
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF009688), // Teal color
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
    
    const NotificationDetails generalNotificationDetails = 
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    int index = 0;
    final now = DateTime.now();
    
    // Schedule notifications only for future events
    child.events.forEach((eventDate, vaccinesList) {
      // Skip past events
      if (eventDate.isBefore(now)) {
        return;
      }
      
      index++;
      
      // Format the message with vaccine names
      final String message = vaccinesList.isNotEmpty 
          ? "Vaccines due: ${vaccinesList.join(', ')}"
          : "It's time to vaccinate your child";
          
      // Convert to TZDateTime for zonedSchedule
      final tz.TZDateTime scheduledTime = tz.TZDateTime.from(eventDate, tz.local);
      
      try {
        fltrNotification.zonedSchedule(
          index, 
          "Vaccine Reminder for ${child.name}",
          message,
          scheduledTime,
          generalNotificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: 
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        
        print("Scheduled notification $index for $scheduledTime");
      } catch (e) {
        print("Failed to schedule notification: $e");
      }
    });
  }

  Future<void> notificationSelected(String? payload) async {
    // Handle notification tap
    print("Notification tapped: $payload");
  }
}