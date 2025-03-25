import './vaccine.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomMaps {
  final DateTime date;
  final List<dynamic> arr;

  CustomMaps(this.date, this.arr);

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'arr': arr,
      };

  factory CustomMaps.fromJson(Map<String, dynamic> json) {
    return CustomMaps(
      json['date'] is String
          ? DateTime.parse(json['date'])
          : DateTime.fromMillisecondsSinceEpoch(
              json['date'].millisecondsSinceEpoch),
      json['arr'] as List<dynamic>,
    );
  }
}

class Child {
  String? id; // Add this field to store the Firestore document ID
  File? photo;
  String name;
  DateTime dob;
  int gender; // 0 for boy, 1 for girl
  List<Vaccine> vaccines_to_be_reminded = [];
  List<Vaccine> vaccines_date_gone = [];
  Map<DateTime, List<dynamic>> events = {};
  Map<DateTime, List<dynamic>> nextDue = {};

  // Update your constructor to accept an optional id parameter
  Child(this.name, this.dob, this.gender, this.photo, {this.id});

  // Add this factory constructor to your Child class
  factory Child.fromFirestore(Map<String, dynamic> data, String documentId) {
    var dob;
    var time = data['dob'];

    if (time is Timestamp) {
      dob = time.toDate();
    } else if (time is int) {
      dob = DateTime.fromMillisecondsSinceEpoch(time);
    } else {
      // Fallback
      dob = DateTime.now();
    }

    File? photoFile;
    if (data['photoPath'] != null) {
      photoFile = File(data['photoPath']);
    }

    Child child = Child(
      data['name'] ?? 'Unknown',
      dob,
      data['gender'] ?? 0,
      photoFile,
      id: documentId,
    );

    if (data['events'] != null) {
      child.events = child.getEventsfromdatabase(data['events']);
      child.getNextDueVaccines();
    }

    return child;
  }

  // Make sure your toJson method includes the id if available
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'dob': dob
          .millisecondsSinceEpoch, // Store as milliseconds for Firestore compatibility
      'gender': gender,
    };

    // Only include photo path if it exists
    if (photo != null && photo!.path.isNotEmpty) {
      data['photoPath'] = photo!.path;
    }

    // Only include events if they exist
    if (events.isNotEmpty) {
      data['events'] = getJSONfromEvents();
    }

    return data;
  }

  // Define the getJSONfromEvents method
  List<Map<String, dynamic>> getJSONfromEvents() {
    List<Map<String, dynamic>> jsonEvents = [];
    events.forEach((date, arr) {
      jsonEvents.add({
        'date': date.toIso8601String(),
        'arr': arr,
      });
    });
    return jsonEvents;
  }

  Map<DateTime, List<dynamic>> getEventsfromdatabase(List<dynamic> arr) {
    if (arr.isEmpty) return {};

    Map<DateTime, List<dynamic>> events = {};
    for (int it = 0; it < arr.length; it++) {
      // Handle different timestamp formats
      DateTime eventDate;
      var time = arr[it]['date'];

      if (time is String) {
        eventDate = DateTime.parse(time);
      } else {
        try {
          eventDate =
              DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
        } catch (e) {
          print("Error parsing date: $e");
          continue;
        }
      }

      events[eventDate] = arr[it]['arr'];
    }
    return events;
  }

  void makeEvents(List<Vaccine> vaccinesToBeReminded) {
    for (int i = 0; i < vaccinesToBeReminded.length; i++) {
      for (int j = 0; j < vaccinesToBeReminded[i].doses.length; j++) {
        // Skip if reminder is not set for this dose
        if (!vaccinesToBeReminded[i].doses[j].setReminder) {
          continue;
        }

        final dueDate =
            dob.add(Duration(days: vaccinesToBeReminded[i].doses[j].week * 7));

        final eventText =
            "${vaccinesToBeReminded[i].code} - Dose ${vaccinesToBeReminded[i].doses[j].position}";

        // Add event to map, handling case where date already exists
        if (events[dueDate] == null) {
          events[dueDate] = [eventText];
        } else {
          events[dueDate]!.add(eventText);
        }
      }
    }
  }

  void getNextDueVaccines() {
    if (events.isEmpty) {
      return;
    }

    // Filter for future dates only
    final now = DateTime.now();
    final futureDates = events.keys
        .where((date) =>
            date.isAfter(now) ||
            (date.year == now.year &&
                date.month == now.month &&
                date.day == now.day))
        .toList();

    if (futureDates.isEmpty) {
      return; // No future vaccines
    }

    // Sort to find nearest future date
    futureDates.sort((a, b) => a.compareTo(b));
    final nearest = futureDates[0];

    nextDue = {nearest: events[nearest]!};
  }
}
