import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final _firstnameController = TextEditingController();
  final _secondnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _IDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.blue),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20.0),
                    buildInputField(_firstnameController, 'First Name', 'Please enter your First Name'),
                    SizedBox(height: 12.0),
                    buildInputField(_secondnameController, 'Second Name', 'Please enter your Second Name'),
                    SizedBox(height: 12.0),
                    buildInputField(_usernameController, 'Username', 'Please enter a Username'),
                    SizedBox(height: 12.0),
                    buildInputField(_emailController, 'Email', 'Please enter your Email'),
                    SizedBox(height: 12.0),
                    buildInputField(_IDController, 'Student ID', ''),
                    SizedBox(height: 12.0),
                    buildInputField(_phoneController, 'Phone Number', 'Please enter your Phone Number'),
                    SizedBox(height: 12.0),
                    PasswordField(),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
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

  Widget buildInputField(TextEditingController controller, String labelText, String validatorMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: UnderlineInputBorder(),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }
}

class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const UnderlineInputBorder(),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Text(
            _obscureText ? 'Show' : 'Hide',
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a Password';
        }
        return null;
      },
      obscureText: _obscureText,
    );
  }
}