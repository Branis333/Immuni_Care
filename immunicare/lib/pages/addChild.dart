import 'dart:io';

import 'package:flutter/material.dart';
import '../data/child.dart';
import '../pages/select_initial_reminders.dart';
import '../pages/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  _AddChildState createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Class variables
  String _name = "";
  DateTime? _dob;
  String _formattedDate = "";
  int _gender = -1;
  bool _showError = false;

  // Widget for Child Name
  Widget _buildName() {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        key: Key("ChildName"),
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          labelText: "Child Name",
          labelStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Theme.of(context).primaryColorDark),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter child name';
          }
          return null;
        },
        onSaved: (String? value) {
          _name = value ?? "";
        },
      ),
    );
  }

  void _goToSelectReminders(BuildContext context, Child newChild) async {
    Child? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectInitialReminders(
          child: newChild,
        ),
      ),
    );
    if (result != null) {
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/logo.jpg',
                height: 40,
                width: 40,
              ),
              SizedBox(width: 10),
              Text('Add Child'),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Child Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                // Avatar based on gender
                Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Theme.of(context).cardColor
                          : Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _gender == 0
                          ? Icons.boy
                          : _gender == 1
                              ? Icons.girl
                              : Icons.child_care,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                // Add Name
                Container(
                  width: 370,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2),
                    color: isDarkMode
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(children: <Widget>[
                    _buildName(),
                    // Add date of birth through scrollable calendar picker
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Date Of Birth',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _dob == null ? "" : _formattedDate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            child: Text('Pick a date'),
                            onPressed: () async {
                              // Get current dark mode status from BLoC for date picker
                              final isDarkModeForPicker =
                                  context.read<ThemeBloc>().state.isDarkMode;

                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: _dob ?? DateTime.now(),
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: isDarkModeForPicker
                                        ? ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              onPrimary: Colors.white,
                                              surface:
                                                  Theme.of(context).cardColor,
                                              onSurface: Colors.white,
                                            ),
                                            dialogTheme: DialogThemeData(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .canvasColor),
                                          )
                                        : ThemeData.light().copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              onPrimary: Colors.white,
                                              surface: Colors.white,
                                              onSurface: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null && picked != _dob) {
                                setState(() {
                                  _dob = picked;
                                  _formattedDate =
                                      "${picked.day}/${picked.month}/${picked.year}";
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Add the gender of child
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Gender',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Radio<int>(
                            value: 0,
                            groupValue: _gender,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (int? value) {
                              if (value != null) {
                                setState(() {
                                  _gender = value;
                                });
                              }
                            },
                          ),
                          Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: _gender == 0
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                              fontWeight: _gender == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Radio<int>(
                            value: 1,
                            groupValue: _gender,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (int? value) {
                              if (value != null) {
                                setState(() {
                                  _gender = value;
                                });
                              }
                            },
                          ),
                          Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: _gender == 1
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                              fontWeight: _gender == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),

                // Next button - transfer the information
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_dob == null || _gender == -1 || _name.isEmpty) {
                          setState(() {
                            _showError = true;
                          });
                          return;
                        }

                        setState(() {
                          _showError = false;
                        });

                        Child newChild = Child(_name, _dob!, _gender, null);
                        _goToSelectReminders(context, newChild);
                      }
                    },
                    icon: Icon(Icons.arrow_forward_sharp),
                    label: Text("Next"),
                  ),
                ),
                if (_showError)
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Please fill in all the details before proceeding",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
