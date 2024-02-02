import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:affairs_timetable/login.dart';

void main() {
  group('LoginPage Widget Tests', () {
    testWidgets('Renders LoginPage widgets', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      expect(find.text('Log In'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Validates user input and responds to button press', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Invalid email or password. Please try again.'), findsNothing);

      await tester.enterText(find.byType(TextFormField).at(0), 'Lessgoo1');
      await tester.enterText(find.byType(TextFormField).at(1), 'test2');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
    });
  });
}
