import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'edit_profile.dart';
import 'modules.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('http://localhost:8080/api/users/get/${prefs.getInt('id')}'); //2
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          print(jsonDecode(response.body));
          user = User.fromJson(jsonDecode(response.body));
        });
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? CircularProgressIndicator() : buildUserProfile();
  }

  Widget buildUserProfile() {
    final String displayName = user?.firstName ?? 'Loading...';
    final String displayLastName = user?.lastName ?? 'Loading...';
    final String displayUsername = user?.username ?? 'Unavailable';
    final String displayEmail = user?.email ?? 'Loading...';
    final String displayPhoneNumber = user?.phoneNumber ?? 'Loading...';
    final String displayStudentID = user?.id.toString() ?? 'Unavailable';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'User Profile',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                // Assuming EditProfilePage takes a User object to edit
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => EditProfilePage(user: user),
                //   ),
                // );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 24.0),
              Text(
                'User Profile',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 350,
                    height: 1000,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildInfoItem('First Name', displayName),
                            _buildInfoItem('Last Name', displayLastName),
                            _buildInfoItem('Username', displayUsername),
                            _buildInfoItem('Email', displayEmail),
                            _buildInfoItem('Phone Number', displayPhoneNumber),
                            _buildInfoItem('Student ID', displayStudentID),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 16.0),
          Divider(color: Colors.grey),
        ],
      ),
    );
  }
}




