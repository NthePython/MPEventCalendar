import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modules.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  bool isLoading = false;

  Future<bool> authenticateUser(String enteredUsername, String enteredPassword) async {
    var url = Uri.parse('http://localhost:8080/api/users/signIn');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username": enteredUsername,
          "password": enteredPassword,
        }),
      );
      print(response.statusCode);

      if (response.statusCode  == 200) {
        int id = int.parse(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id', id);
        return true;
      } else {
        print('Failed to load user data');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> _saveChanges() async {
    var url = Uri.parse('http://localhost:8080/api/users/update/${widget.user.id}');
    setState(() {
      isLoading = true;
    });

    try {
      bool isAuthenticated = await authenticateUser(widget.user.username ?? "sheesh", currentPasswordController.text);

      if (!isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed')),
        );
        return;
      }

      var firstName = firstNameController.text.isNotEmpty ? firstNameController.text : widget.user.firstName;
      var lastName = lastNameController.text.isNotEmpty ? lastNameController.text : widget.user.lastName;
      var email = emailController.text.isNotEmpty ? emailController.text : widget.user.email;
      var phoneNumber = phoneNumberController.text.isNotEmpty ? phoneNumberController.text : widget.user.phoneNumber;
      var password = newPasswordController.text.isNotEmpty ? newPasswordController.text : currentPasswordController.text;

      var response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': widget.user.id.toString(),
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
          'username': widget.user.username ?? "sheesh",
          'password': password ?? "sheesh",
          'joinedDate': widget.user.joinedDate
        }),
      );

      if (response.statusCode == 200) {
        print('User updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pushNamed(context, '/profile');
      } else {
        print('Failed to update user: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    } catch (e) {
      print('Error updating user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 24.0),
            _buildTextField('First Name', firstNameController),
            _buildTextField('Last Name', lastNameController),
            _buildTextField('Email', emailController),
            _buildTextField('Phone Number', phoneNumberController),
            _buildPasswordField('Current Password', currentPasswordController),
            _buildPasswordField('New Password', newPasswordController),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
          TextFormField(
            controller: controller,
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool _obscureText = true;

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
              TextFormField(
                controller: controller,
                style: TextStyle(fontSize: 14.0),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
