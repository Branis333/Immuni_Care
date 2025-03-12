import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'baby_registry_screen.dart';
import 'scheduling_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ImmuniCare Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _navButton(context, "Go to Dashboard", DashboardScreen()),
            _navButton(context, "Go to Baby Registry", BabyRegistryScreen()),
            _navButton(context, "Go to Scheduling", SchedulingScreen()),
            _navButton(context, "Go to Community", CommunityScreen()),
            _navButton(context, "Go to Profile", DoctorProfileApp()),
          ],
        ),
      ),
    );
  }

  Widget _navButton(BuildContext context, String text, Widget screen) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
        child: Text(text),
      ),
    );
  }
}
