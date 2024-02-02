import 'package:flutter/material.dart';
import 'signup.dart';
import 'modules.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late User user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void initState() {
    super.initState();
  }



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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 24.0),
              Text(
                'Log In',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              PasswordField(
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  return null;
                },
              ),
              SizedBox(height: 64.0),
              SizedBox(
                height: 50.0,
                width: 150.0,
                child: ElevatedButton(
                  onPressed: () async {
                    if (true) {
                      String enteredUsername = _usernameController.text;
                      String enteredPassword = _passwordController.text;

                      bool isAuthenticated = await authenticateUser(enteredUsername, enteredPassword);

                      if (isAuthenticated) {
                        Navigator.pushNamed(context, '/home'); // Navigate to the home page
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid email or password. Please try again.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text('Login'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.redAccent,
                        ),
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
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const PasswordField({Key? key, this.controller, this.validator}) : super(key: key);

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
