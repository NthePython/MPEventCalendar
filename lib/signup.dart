import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'modules.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _secondnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _IDController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordController2 = TextEditingController();
  User? user;

  void fetchUserData() async {
    var url = Uri.parse('http://localhost:8080/api/users/signIn'); //${user!.id}
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        int id = int.parse(response.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id', id);
      } else {
        print('Failed to load user data');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  void submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> userData = {
        'first_name': _firstnameController.text,
        'second_name': _secondnameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone_number': _phoneController.text,
        'password': _passwordController.text,
        'password2' : _passwordController2.text,
      };

      String jsonData = jsonEncode(userData);

      var url = Uri.parse('http://localhost:8080/api/users/signUp');

      try {
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonData,
        );

        if (response.statusCode == 200) {
          Navigator.pushNamed(context, '/home');
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: 'First Name*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your First Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _secondnameController,
                      decoration: InputDecoration(
                        labelText: 'Second Name*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Second Name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an Username';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.0),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number*',
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone Number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.0),
                    PasswordField(
                      controller: _passwordController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 12.0),
                    PasswordField(
                      controller: _passwordController2,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a Password';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 24.0),
                    SizedBox(
                      height: 40.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: submitForm,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  PasswordField({required this.controller, this.validator});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Text(
            _obscureText ? 'Show' : 'Hide',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
      validator: widget.validator,
      obscureText: _obscureText,
    );
  }
}
