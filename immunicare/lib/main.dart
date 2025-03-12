import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(ImmuniCareApp());
}

class ImmuniCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ImmuniCare',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: SplashScreen(),
    );
  }
}
