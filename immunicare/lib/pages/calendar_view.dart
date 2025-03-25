import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:immunicare/data/child.dart';
import '../pages/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

int userChoice = 0;

class Mapping {
  Child child;
  int index;
  Mapping(this.index, this.child);
}

class CalendarPage extends StatefulWidget {
  final List<Child> children;
  const CalendarPage({super.key, required this.children});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  late Map<DateTime, List<dynamic>> _events;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _events = widget.children.isEmpty ? {} : widget.children[0].events;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    void showAddDialog() async {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).cardColor,
                content: Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Positioned(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Select Child',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          ShowChildren(widget.children),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton.extended(
                                key: Key('Submit'),
                                label: Text('Go'),
                                backgroundColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _events = widget.children.isEmpty
                                        ? {}
                                        : widget.children[userChoice].events;
                                    if (_selectedDay != null) {
                                      _selectedEvents.value =
                                          _getEventsForDay(_selectedDay!);
                                    }
                                  });
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
    }

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
            Text('Calendar'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: SizedBox(
        height: 50.0,
        width: 200.0,
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(Icons.child_care),
          label: Text("Select Child"),
          onPressed: showAddDialog,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(50),
              child: Text(
                'Calendar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: isDarkMode
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                            0.1,
                            0.4,
                            0.8,
                            0.9
                          ],
                        colors: [
                            Theme.of(context).cardColor,
                            Theme.of(context).canvasColor,
                            Theme.of(context).canvasColor.withOpacity(0.9),
                            Theme.of(context).cardColor,
                          ])
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [
                            0.1,
                            0.4,
                            0.8,
                            0.9
                          ],
                        colors: [
                            Theme.of(context).primaryColor.withOpacity(0.05),
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.2),
                            Theme.of(context).primaryColor.withOpacity(0.1),
                          ]),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    eventLoader: _getEventsForDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _selectedEvents.value = _getEventsForDay(selectedDay);
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: isDarkMode
                            ? Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.7)
                            : Theme.of(context).primaryColorLight,
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                      markersMaxCount: 3,
                      markersAlignment: Alignment.bottomCenter,
                    ),
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      formatButtonTextStyle: TextStyle(color: Colors.white),
                      formatButtonShowsNext: false,
                      titleTextStyle: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, _) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      todayBuilder: (context, date, _) {
                        return Container(
                          margin: const EdgeInsets.all(5.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        if (events.isEmpty) return null;
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return Column(
                  children: value
                      .map((event) => ListTile(
                            leading: Icon(
                              Icons.add_alarm,
                              color: Theme.of(context).primaryColor,
                            ),
                            trailing: Text(
                              'For ${widget.children[userChoice].name}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            title: Text(
                              event,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// This class is used to display a list of structures in dialogue box preceded by the radio buttons
class ShowChildren extends StatefulWidget {
  final List<Child> children;
  const ShowChildren(this.children, {super.key});

  @override
  _ShowChildrenState createState() => _ShowChildrenState();
}

class _ShowChildrenState extends State<ShowChildren> {
  int choosenIndex = 0;
  List<Mapping> choices = [];

  @override
  void initState() {
    super.initState();
    userChoice =
        0; // By default the first structure will be displayed as selected
    for (int i = 0; i < widget.children.length; i++) {
      choices.add(Mapping(i, widget.children[i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Access ThemeBloc for dialog
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return SizedBox(
      // Wrapping ListView inside Container to assign scrollable screen a height and width
      width: screenWidth / 2,
      height: screenHeight / 3,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: choices
            .map((entry) => RadioListTile(
                  key: Key('Child ${entry.index}'),
                  title: Text(
                    entry.child.name,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Theme.of(context).primaryColorDark,
                    ),
                  ),
                  groupValue: choosenIndex,
                  activeColor: Theme.of(context).primaryColor,
                  value: entry.index,
                  onChanged: (value) {
                    // A radio button gets selected only when groupValue is equal to value of the respective radio button
                    setState(() {
                      if (value != null) {
                        userChoice = value;
                        choosenIndex = value;
                      }
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}