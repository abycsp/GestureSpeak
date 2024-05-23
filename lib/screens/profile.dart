import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:sign_language_app/auth/login_screen.dart';
import 'package:sign_language_app/components/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_language_app/components/snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showPassword = false;
  bool _isEditing = false;

  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  void fetchUserData() async {
    try {
      // Obtain an ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');

      // Check if the userId is not null
      if (userId != null) {
        // Retrieve the document from Firestore
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

        // Check if the document exists and return its data
        if (userDoc.exists) {
          setState(() {
            _fullName = userDoc['name'];
            _email = userDoc['email'];
            _password = userDoc['password'];
          });
        } else {
          print("No user found with ID $userId");
          return null;
        }
      } else {
        print("User ID not found in SharedPreferences");
        return null;
      }
    } catch (e) {
      print("An error occurred while fetching user data: $e");
      return null;
    }
}

  @override
  initState(){
    super.initState();
    fetchUserData();
  }

  void updateUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');

    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    final newData = {
      "name": _fullName,
      "email": _email,
      "password": _password
    };

    try {
      await userRef.update(newData);
      print("User data updated successfully.");
    } catch (e) {
      print("Error updating document: $e");
    }
  }

  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => const ConfirmDialog(
        titleText: 'Confirm Logout',
        contentText: 'Do you want to logout?',
      ),
    ).then((value) => value ?? false);
  }

  Future<void> _showEditProfileDialog() async {
    String editedFullName = _fullName;
    String editedEmail = _email;
    String editedPassword = _password;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  onChanged: (value) {
                    editedFullName = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) {
                    editedEmail = value;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: (value) {
                    editedPassword = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _fullName = editedFullName;
                  _email = editedEmail;
                  _password = editedPassword;
                  _isEditing = false;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('static/images/dp.jpg'), // Replace with your profile picture
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _isEditing
                          ? TextFormField(
                              initialValue: _fullName,
                              onChanged: (value) {
                                setState(() {
                                  _fullName = value;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                            )
                          : Text(
                              'Full Name: $_fullName',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                      const SizedBox(height: 12),
                      _isEditing
                          ? TextFormField(
                              initialValue: _email,
                              readOnly: true,
                              onChanged: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                            )
                          : Text(
                              'Email: $_email',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
                            ),
                      const SizedBox(height: 12),
                      _isEditing
                          ? Column(
                              children: [
                                TextFormField(
                                  initialValue: _password,
                                  onChanged: (value) {
                                    setState(() {
                                      _password = value;
                                    });
                                  },
                                  decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  initialValue: '',
                                  onChanged: (value) {
                                    setState(() {
                                      _confirmPassword = value;
                                    });
                                  },
                                  decoration: InputDecoration(labelText: 'Confirm Password', border: OutlineInputBorder()),
                                ),
                              ],
                          )
                          : Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _showPassword ? _password : '********',
                                    style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(_isEditing == false){
                          setState(() {
                            _isEditing = !_isEditing;
                          }); 
                        } else if (_password == _confirmPassword && _isEditing == true) {
                          updateUserData();
                          setState(() {
                            _isEditing = !_isEditing;
                            _confirmPassword = '';
                          }); 
                          final snackBar = buildCustomSnackBar(
                            text: 'Updated User Data',
                            type: SnackBarType.success,
                            duration: const Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = buildCustomSnackBar(
                            text: 'Password is not the same',
                            type: SnackBarType.error,
                            duration: const Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text(_isEditing ? 'Save' : 'Edit Profile', style: TextStyle(fontFamily: 'Poppins')),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red, // Sets the background color to red
                      ),
                      onPressed: () async {
                        bool confirmLogout = await _showLogoutConfirmationDialog(context);
                        if (confirmLogout) {
                          // remove key 
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('user_id');
                          // back to login screen
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
                      child: const Text('Logout', style: TextStyle(fontFamily: 'Poppins')),
                    ),
                    
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

