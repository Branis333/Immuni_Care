import 'package:flutter/material.dart';
import './child.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class AllChildren extends StatefulWidget {
  final List<Child> children;
  final Function(Child) updateChild;
  final Function(Child) deleteChild;

  const AllChildren({
    super.key,
    required this.children,
    required this.updateChild,
    required this.deleteChild,
  });

  @override
  _AllChildrenState createState() => _AllChildrenState();
}

class _AllChildrenState extends State<AllChildren> {
  void _showDeleteConfirmation(Child child) {
    // Using BLoC instead of Provider for theme
    final isDarkMode = context.read<ThemeBloc>().state.isDarkMode;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              isDarkMode ? Theme.of(context).cardColor : Colors.white,
          title: Text(
            "Delete Child",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete ${child.name}?",
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                widget.deleteChild(child);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(Child child) {
    // Using BLoC instead of Provider for theme
    final isDarkMode = context.read<ThemeBloc>().state.isDarkMode;
    TextEditingController nameController =
        TextEditingController(text: child.name);
    DateTime selectedDob = child.dob;
    int selectedGender = child.gender;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor:
                  isDarkMode ? Theme.of(context).cardColor : Colors.white,
              title: Text(
                "Edit Child",
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.white70
                              : Theme.of(context).primaryColorDark,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Date of Birth: ",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        TextButton(
                          child: Text(
                            "${selectedDob.day}/${selectedDob.month}/${selectedDob.year}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDob,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: isDarkMode
                                      ? ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary:
                                                Theme.of(context).primaryColor,
                                            onPrimary: Colors.white,
                                            surface:
                                                Theme.of(context).cardColor,
                                            onSurface: Colors.white,
                                          ),
                                          dialogBackgroundColor:
                                              Theme.of(context).canvasColor,
                                        )
                                      : ThemeData.light().copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary:
                                                Theme.of(context).primaryColor,
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
                            if (picked != null && picked != selectedDob) {
                              setState(() {
                                selectedDob = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          "Gender: ",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedGender = 0; // Boy
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.boy,
                                color: selectedGender == 0
                                    ? Theme.of(context).primaryColor
                                    : isDarkMode
                                        ? Colors.white54
                                        : Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Boy",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 24),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedGender = 1; // Girl
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.girl,
                                color: selectedGender == 1
                                    ? Theme.of(context).primaryColor
                                    : isDarkMode
                                        ? Colors.white54
                                        : Colors.grey,
                              ),
                              SizedBox(width: 4),
                              Text(
                                "Girl",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: () {
                    // Update child object
                    child.name = nameController.text;
                    child.dob = selectedDob;
                    child.gender = selectedGender;

                    // Call the update callback
                    widget.updateChild(child);

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget childTemplate(Child ch) {
    // Using BLoC instead of Provider for theme
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: isDarkMode
              ? Theme.of(context).primaryColor.withOpacity(0.3)
              : Theme.of(context).primaryColor.withOpacity(0.2),
          child: Icon(
            ch.gender == 0 ? Icons.boy : Icons.girl,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
        title: Text(
          ch.name,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        subtitle: Text(
          // Format date as dd/mm/yyyy
          "Born: ${ch.dob.day}/${ch.dob.month}/${ch.dob.year}",
          style: TextStyle(
            fontSize: 14.0,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: () {
                _showEditDialog(ch);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteConfirmation(ch);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Using BLoC instead of Provider for theme
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
            Text('All Children'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: widget.children.isEmpty
          ? Center(
              child: Text(
                'No children added yet',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.children.length,
              itemBuilder: (context, index) {
                return childTemplate(widget.children[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}