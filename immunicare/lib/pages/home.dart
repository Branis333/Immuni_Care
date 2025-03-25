import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:immunicare/controllers/authentication.dart';
import 'package:immunicare/pages/calendar_view.dart';
import 'package:immunicare/data/child.dart';
import 'package:immunicare/pages/addChild.dart';
import 'package:immunicare/pages/login_screen.dart';
import 'package:immunicare/pages/profilePage.dart';
import 'package:immunicare/pages/contactUs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:immunicare/data/allChildren.dart';
import 'package:immunicare/data/news.dart';
import 'package:immunicare/data/news_details.dart';
import 'package:provider/provider.dart';
import 'package:immunicare/theme/theme_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

void _onTapItem(BuildContext context, Article article) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => NewsDetails(article)));
}

List<Child> children = [];

class MyHomePage extends StatefulWidget {
  final String uid;
  const MyHomePage({super.key, required this.uid});

  @override
  _MyHomePageState createState() => _MyHomePageState(uid);
}

class _MyHomePageState extends State<MyHomePage> {
  final String uid;
  _MyHomePageState(this.uid);
  final CollectionReference user =
      FirebaseFirestore.instance.collection('users');
  int _index = 0;
  int numCards = 1;

  _addChild(Child newChild) async {
    try {
      print("Saving child to Firestore: ${newChild.name}");
      print("Using UID: $uid");

      DocumentReference docRef =
          await user.doc(uid).collection('children').add(newChild.toJson());

      print("SUCCESS: Child saved with document ID: ${docRef.id}");

      // Update the child with document ID
      newChild.id = docRef.id;

      setState(() {
        children.add(newChild);
      });
    } catch (error) {
      print("ERROR saving child: $error");
    }
  }

  Future<void> getChildrenFromDatabase() async {
    try {
      print("Getting children from database for UID: $uid");

      // Clear existing children to avoid duplicates
      setState(() {
        children.clear();
      });

      if (uid == null || uid.isEmpty) {
        print("ERROR: UID is null or empty - cannot load children");
        return;
      }

      QuerySnapshot querySnapshot =
          await user.doc(uid).collection('children').get();

      print("Found ${querySnapshot.docs.length} children in database");

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          numCards = 1; // Set to default if no children
        });
        return;
      }

      for (var doc in querySnapshot.docs) {
        try {
          var data = doc.data() as Map<String, dynamic>;

          // Log the document data for debugging
          print(
              "Child document data: ${data.toString().substring(0, min(100, data.toString().length))}...");

          // Use the factory constructor
          Child child = Child.fromFirestore(data, doc.id);

          setState(() {
            children.add(child);
          });

          print(
              "Successfully loaded child: ${child.name} with ID: ${child.id}");
        } catch (e) {
          print("Error processing child document ${doc.id}: $e");
        }
      }

      setState(() {
        numCards = children.isEmpty ? 1 : children.length;
      });

      print("Final children list size: ${children.length}");
    } catch (e) {
      print("Error in getChildrenFromDatabase: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    print("HomePage initState - UID: $uid");
    getChildrenFromDatabase(); // 
  }

  void _goToAddChildPage(BuildContext context) async {
    Child? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddChild(),
      ),
    );

    if (result != null) {
      _addChild(result);
    }

    setState(() {
      numCards = children.isEmpty ? 1 : children.length;
    });

    if (children.isNotEmpty) {
      for (Child child in children) {
        child.getNextDueVaccines();
      }
    }
  }

  // Updating a child in Firestore
  Future<void> updateChild(Child child) async {
    if (child.id == null) {
      print("Cannot update child: missing document ID");
      return;
    }

    try {
      await user
          .doc(uid)
          .collection('children')
          .doc(child.id)
          .update(child.toJson());
      print("Child updated successfully: ${child.id}");
    } catch (error) {
      print("Error updating child: $error");
    }
  }

  // Delete a child from Firestore
  Future<void> deleteChild(Child child) async {
    if (child.id == null) {
      print("Cannot delete child: missing document ID");
      return;
    }

    try {
      await user.doc(uid).collection('children').doc(child.id).delete();

      setState(() {
        children.removeWhere((c) => c.id == child.id);
        numCards = children.isEmpty ? 1 : children.length;
      });
      print("Child deleted successfully: ${child.id}");
    } catch (error) {
      print("Error deleting child: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replace Provider with BLoC
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 6 : 4 : 4 : 1
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.antiAlias,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 80.0),
                      padding: EdgeInsets.all(0),
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
                                    Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.8),
                                    Theme.of(context).cardColor,
                                    Theme.of(context).canvasColor,
                                    Theme.of(context)
                                        .canvasColor
                                        .withOpacity(0.9),
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
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    Theme.of(context).primaryColor,
                                  ]),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Positioned(
                          top: 20,
                          left: 25,
                          child: Image.asset(
                            'assets/logo.jpg',
                            height: 60,
                            width: 60,
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 25,
                          child: Text(
                            'IMMUNICARE',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 170.0),
                          child: SizedBox(
                            height: 160, // slightly taller card height
                            child: PageView.builder(
                              itemCount: numCards,
                              controller: PageController(viewportFraction: 0.8),
                              onPageChanged: (int index) =>
                                  setState(() => _index = index),
                              itemBuilder: (_, i) {
                                return Transform.scale(
                                  scale: i == _index ? 1 : 0.9,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Theme.of(context).primaryColor // Solid color for dark mode
                                          : Theme.of(context).primaryColor,   // Solid color for light mode
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 4),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: (children.isNotEmpty &&
                                            i < children.length)
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 12.0),
                                                child: Text(
                                                  children[i].name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ),
                                              if (children[i].nextDue.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                  child: Text(
                                                    "Next Due: ${children[i].nextDue.keys.first.day}/${children[i].nextDue.keys.first.month}/${children[i].nextDue.keys.first.year}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor: Colors.white,
                                                      child: Icon(
                                                        children[i].gender == 0
                                                            ? Icons.boy
                                                            : Icons.girl,
                                                        size: 40,
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                    if (children[i].nextDue.isNotEmpty)
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 16.0),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              for (var next in children[i].nextDue.values.first)
                                                                Padding(
                                                                  padding: const EdgeInsets.only(bottom: 4.0),
                                                                  child: Text(
                                                                    next,
                                                                    style: TextStyle(
                                                                      fontSize: 15,
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w700,
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.child_care,
                                                  color: Colors.white,
                                                  size: 48,
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  "No Child Added",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Tap + button to add",
                                                  style: TextStyle(
                                                    color: Colors.white.withOpacity(0.8),
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                color: isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).primaryColorDark,
                                onPressed: () {
                                  _goToAddChildPage(context);
                                },
                              ),
                            ),
                            Text(
                              'Add Child',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.list_alt),
                                color: isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).primaryColorDark,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllChildren(
                                        children: children,
                                        updateChild: updateChild,
                                        deleteChild: deleteChild,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              'View All',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.calendar_today_rounded),
                                color: isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).primaryColorDark,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CalendarPage(
                                        children: children,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Text(
                              'Calendar View',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.notifications_active),
                                color: isDarkMode
                                    ? Colors.white
                                    : Theme.of(context).primaryColorDark,
                                tooltip: "Set Reminder",
                                onPressed: () {
                                  Navigator.pushNamed(context, '/localNotif');
                                },
                              ),
                            ),
                            Text(
                              'Set a',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Reminder',
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Health News",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<List<Article>>(
                        future: News.getNewsArticles(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print("Error loading news: ${snapshot.error}");
                            return Center(child: Text('Error loading news'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No news available'));
                          }

                          // Display the news articles
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Article article = snapshot.data![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NewsDetails(article),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 220,
                                  margin: EdgeInsets.only(
                                      left: index == 0 ? 16 : 8, right: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isDarkMode
                                        ? Theme.of(context).cardColor
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: article.urlToImage != null
                                            ? Image.network(
                                                article.urlToImage!,
                                                height: 110,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (ctx, err, _) =>
                                                    Container(
                                                  height: 110,
                                                  color: isDarkMode
                                                      ? Colors.grey[800]
                                                      : Colors.grey[300],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: isDarkMode
                                                        ? Colors.white70
                                                        : Colors.black54,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 110,
                                                color: isDarkMode
                                                    ? Colors.grey[800]
                                                    : Colors.grey[300],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: isDarkMode
                                                      ? Colors.white70
                                                      : Colors.black54,
                                                ),
                                              ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            article.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: isDarkMode
                      ? Theme.of(context).canvasColor
                      : Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.contact_page,
                          color: isDarkMode
                              ? Colors.white
                              : Theme.of(context).primaryColorDark,
                        ),
                        tooltip: 'Contact Us',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactUsPage(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person,
                          color: isDarkMode
                              ? Colors.white
                              : Theme.of(context).primaryColorDark,
                        ),
                        tooltip: 'Profile Page',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(uid: uid),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: isDarkMode
                              ? Colors.white
                              : Theme.of(context).primaryColorDark,
                        ),
                        tooltip: 'Log Out',
                        onPressed: () => signOutUser().then((value) {
                          children = [];
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }),
                      ),
                      IconButton(
                        icon: BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return Icon(
                              state.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              color: state.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColorDark,
                            );
                          },
                        ),
                        tooltip: 'Toggle Theme',
                        onPressed: () {
                          context.read<ThemeBloc>().add(ToggleThemeEvent());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
