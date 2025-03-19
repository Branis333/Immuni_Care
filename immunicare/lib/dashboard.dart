import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  
  get image => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set a valid color for the background
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/drmohar.png'), // Add an image asset
                  ),
                  SizedBox(height: 10),
                  Text(
                    "DrMohar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Schedule"),
              onTap: () {
                Navigator.pushNamed(context, '/schedule');
              },
            ),
            ListTile(
              leading: Icon(Icons.child_care),
              title: Text("Baby Registry"),
              onTap: () {
                // Navigate to Baby Registry page
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Community"),
              onTap: () {
                Navigator.pushNamed(context, '/community');
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text("Engagement"),
              onTap: () {
                // Navigate to Engagement page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                // Navigate to Settings page
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/comm_enage2.webp'), // Add an image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text("Welcome to the Dashboard!"),
        ),
      ),
    );
  }
}