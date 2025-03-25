import 'package:flutter/material.dart';
import '../data/allVaccines.dart';
import '../data/vaccine.dart';
import 'package:immunicare/data/child.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class SelectInitialReminders extends StatefulWidget {
  final Child child;
  const SelectInitialReminders({super.key, required this.child});

  @override
  _SelectInitialRemindersState createState() => _SelectInitialRemindersState();
}

class _SelectInitialRemindersState extends State<SelectInitialReminders> {
  @override
  void initState() {
    super.initState();
    processVaccines();
  }

  void processVaccines() {
    // Clear existing data to prevent duplicates
    widget.child.vaccines_date_gone.clear();
    widget.child.vaccines_to_be_reminded.clear();

    for (int index = 0; index < AllVaccines.allVaccines.length; index++) {
      List<Dose> given = [];
      List<Dose> toBeGiven = [];
      Vaccine currVaccine = AllVaccines.allVaccines[index];

      for (var dose in currVaccine.doses) {
        // Calculate the exact date when this dose should be given
        DateTime doseDate = widget.child.dob.add(Duration(days: dose.week * 7));

        if (DateTime.now().isAfter(doseDate)) {
          given.add(dose);
        }
        if (DateTime.now().isBefore(doseDate)) {
          toBeGiven.add(dose);
        }
      }

      widget.child.vaccines_date_gone.add(Vaccine(currVaccine.name,
          currVaccine.code, currVaccine.description, given, currVaccine.price));

      widget.child.vaccines_to_be_reminded.add(Vaccine(
          currVaccine.name,
          currVaccine.code,
          currVaccine.description,
          toBeGiven,
          currVaccine.price));
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
            Text('Vaccine Reminders'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Done',
        onPressed: () {
          widget.child.makeEvents(widget.child.vaccines_to_be_reminded);
          Navigator.pop(
            context,
            widget.child,
          );
        },
        child: Icon(Icons.check),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Vaccine Reminders',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),

              // Past vaccines section
              _buildInfoBox(
                context,
                "Past Vaccines",
                "List of vaccines the child should have taken by now. If not taken, CONTACT YOUR DOCTOR.",
                isDarkMode
                    ? Theme.of(context).cardColor
                    : Theme.of(context).primaryColor.withOpacity(0.05),
              ),

              widget.child.vaccines_date_gone.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No past vaccines to show",
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.child.vaccines_date_gone.length,
                      itemBuilder: (BuildContext context, int index) {
                        final vaccine = widget.child.vaccines_date_gone[index];
                        if (vaccine.doses.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Column(
                          children: <Widget>[
                            for (var dose in vaccine.doses)
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                elevation: 2,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: CheckboxListTile(
                                    activeColor: Theme.of(context).primaryColor,
                                    dense: true,
                                    title: Text(
                                      "${vaccine.name} Dose ${dose.position}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                    value: dose.setReminder,
                                    subtitle: Text(
                                      dose.isNormal
                                          ? vaccine.code
                                          : "${vaccine.code}\nThis dose is only for specific groups",
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[700],
                                      ),
                                    ),
                                    onChanged: (bool? val) {
                                      setState(() {
                                        dose.setReminder = val ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

              // Future vaccines section
              _buildInfoBox(
                context,
                "Future Vaccines",
                "Reminders for these vaccines will be set. Adjust as recommended by your doctor.",
                isDarkMode
                    ? Theme.of(context).canvasColor
                    : Theme.of(context).primaryColor.withOpacity(0.1),
              ),

              widget.child.vaccines_to_be_reminded.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No upcoming vaccines to schedule",
                          style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.child.vaccines_to_be_reminded.length,
                      itemBuilder: (BuildContext context, int index) {
                        final vaccine =
                            widget.child.vaccines_to_be_reminded[index];
                        if (vaccine.doses.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Column(
                          children: <Widget>[
                            for (var dose in vaccine.doses)
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                elevation: 2,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: dose.setReminder
                                          ? Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.3)
                                          : Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: CheckboxListTile(
                                    activeColor: Theme.of(context).primaryColor,
                                    dense: true,
                                    title: Text(
                                      "${vaccine.name} Dose ${dose.position}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                    value: dose.setReminder,
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dose.isNormal
                                              ? vaccine.code
                                              : "${vaccine.code}\nThis dose is only for specific groups",
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.grey[400]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          "Due on: ${_formatDueDate(widget.child.dob, dose.week)}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onChanged: (bool? val) {
                                      setState(() {
                                        dose.setReminder = val ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

              // Add some padding at the bottom for better scrolling
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(
      BuildContext context, String title, String message, Color color) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          SizedBox(height: 5),
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime birthDate, int weeks) {
    final dueDate = birthDate.add(Duration(days: weeks * 7));
    return "${dueDate.day}/${dueDate.month}/${dueDate.year}";
  }
}