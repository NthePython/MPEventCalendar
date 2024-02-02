import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'affair_page.dart';

class Participant {
  final int id;
  final int userId;
  final int eventId;
  final String? role;

  Participant({
    required this.id,
    required this.userId,
    required this.eventId,
    this.role,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'],
      userId: json['userId'],
      eventId: json['eventId'],
      role: json['role'],
    );
  }
}


class User {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String? username;
  final String? password;
  final String joinedDate;
  final double balance;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    this.username,
    this.password,
    required this.joinedDate,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      username: json['username'],
      password: json['password']== null ? null : "",
      joinedDate: json['joinedDate'],
      balance: json['balance'],
    );
  }
}


class Event {
  final int id;
  final String name;
  final String description;
  final String? place;
  final DateTime startTime;
  final DateTime endTime;
  final double cost;
  final bool allDay;
  final String? type;

  Event({
    required this.id,
    required this.name,
    required this.description,
    this.place,
    required this.startTime,
    required this.endTime,
    required this.cost,
    required this.allDay,
    this.type,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      place: json['place'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      cost: json['cost'].toDouble(),
      allDay: json['allDay'],
      type: json['eventType'],
    );
  }
}



class EventWidget extends StatelessWidget {
  final int id;
  final String? name;
  final String? description;
  final String? place;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? cost;
  final String? type;

  EventWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.place,
    required this.startTime,
    required this.endTime,
    required this.cost,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(fontWeight: FontWeight.bold);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name ?? '', style: boldStyle.copyWith(fontSize: 18.0)),
            SizedBox(height: 8.0),
            buildEventDetails(),
          ],
        ),
        subtitle: buildEventActions(context),
      ),
    );
  }

  Widget buildEventDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description ?? ''),
            SizedBox(height: 8.0),
            Text('Location: ${place ?? ''}'),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start: ${_formatDateTime(startTime)}'),
            SizedBox(height: 8.0),
            Text('End: ${_formatDateTime(endTime)}'),
          ],
        ),
      ],
    );
  }

  Widget buildEventActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Text('Cost: \$${cost?.toStringAsFixed(2) ?? '0.00'}', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Text('Type: ${type ?? ''}', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.0),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventPage(eventId: '${id}'),
                ),
              );
            },
            child: Text('More >>'),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('MMM d, H:mm').format(dateTime);
  }
}
