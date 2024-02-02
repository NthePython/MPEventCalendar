import 'package:affairs_timetable/login.dart';
import 'package:affairs_timetable/profile_page.dart';
import 'package:affairs_timetable/upcoming.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'add_affair_page.dart';
import 'main_page.dart';
import 'profile_test.dart';
import 'upcoming.dart';

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
        '/addForm': (context) => AffairFormPage(),
        '/profile': (context) => ProfilePage(),
        '/upcoming': (context) => UpcomingAffairsPage()
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
