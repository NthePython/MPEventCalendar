import 'login.dart';
import 'profile_page.dart';
import 'upcoming.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'add_affair_page.dart';
import 'main_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/addForm': (context) => EventFormPage(),
        '/profile': (context) => ProfilePage(),
        '/upcoming': (context) => UpcomingEventsPage()
      },
    );



    //   MaterialApp(
    //   title: 'Sign Up Example',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: HomePage(),
    // );
  }
}
