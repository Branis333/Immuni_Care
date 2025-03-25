import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/authentication.dart';
import 'login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immunicare/theme/bloc.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  String _name = '';
  String _email = '';
  String _phone = '';
  bool _isEditingProfile = false;
  bool _isLoading = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      User? user = _auth.currentUser;
      if (user != null) {
        _email = user.email ?? '';

        // Get additional user data from Firestore
        DocumentSnapshot userData = await _users.doc(widget.uid).get();

        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          setState(() {
            _name = data['name'] ?? '';
            _phone = data['phone'] ?? '';

            _nameController.text = _name;
            _phoneController.text = _phone;
          });
        }
      }
    } catch (e) {
      print("Error loading profile data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        setState(() {
          _isLoading = true;
        });

        // Update Firestore
        await _users.doc(widget.uid).set({
          'name': _nameController.text,
          'phone': _phoneController.text,
          'email': _email,
        }, SetOptions(merge: true));

        setState(() {
          _name = _nameController.text;
          _phone = _phoneController.text;
          _isEditingProfile = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red[400],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
            Text('Profile'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(_isEditingProfile ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditingProfile) {
                _updateProfile();
              } else {
                setState(() {
                  _isEditingProfile = true;
                });
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  SizedBox(height: 24),
                  _isEditingProfile
                      ? _buildEditForm(context)
                      : _buildProfileInfo(context),
                  SizedBox(height: 24),
                  _buildLogoutButton(context),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: isDarkMode
              ? Theme.of(context).cardColor
              : Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            _name.isNotEmpty ? _name[0].toUpperCase() : '?',
            style: TextStyle(
              fontSize: 48,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          _name.isNotEmpty ? _name : 'User',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          _email,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
              title: Text(
                'Name',
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              subtitle: Text(
                _name.isNotEmpty ? _name : 'Not set',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(
              color: isDarkMode
                  ? Colors.grey[800]
                  : Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            ListTile(
              leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
              title: Text(
                'Email',
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              subtitle: Text(
                _email,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Divider(
              color: isDarkMode
                  ? Colors.grey[800]
                  : Theme.of(context).primaryColor.withOpacity(0.1),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: Text(
                'Phone',
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ),
              subtitle: Text(
                _phone.isNotEmpty ? _phone : 'Not set',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    // Using BLoC instead of Provider
    final isDarkMode = context.watch<ThemeBloc>().state.isDarkMode;

    return Form(
      key: _formKey,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? Colors.white70
                        : Theme.of(context).primaryColorDark,
                  ),
                  icon:
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                style: Theme.of(context).textTheme.bodyMedium,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? Colors.white70
                        : Theme.of(context).primaryColorDark,
                  ),
                  icon:
                      Icon(Icons.email, color: Theme.of(context).primaryColor),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium,
                enabled: false, // Email cannot be changed
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(
                    color: isDarkMode
                        ? Colors.white70
                        : Theme.of(context).primaryColorDark,
                  ),
                  icon:
                      Icon(Icons.phone, color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
                style: Theme.of(context).textTheme.bodyMedium,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            signOutUser().then((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            });
          },
          icon: Icon(Icons.exit_to_app),
          label: Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          label: Text('Back to Home'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}