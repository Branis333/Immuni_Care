import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/bloc/schedule/schedule_bloc.dart';
import '/dashboard.dart';
import '/schedule.dart';
import '/community.dart';
import '/bloc/community/community_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CommunityBloc()), // Ensure CommunityBloc is available
        BlocProvider(create: (context) => ScheduleBloc()),
      ],
      child: MaterialApp(
        title: 'Health App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => DashboardPage(),
          '/schedule': (context) => SchedulePage(),
          '/community': (context) => CommunityScreen(),
        },
      ),
    );
  }
}
