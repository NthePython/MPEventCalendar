import 'package:flutter/material.dart';
import 'modules.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EventPage extends StatefulWidget {
  final String eventId;

  EventPage({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Event? event;
  bool isLoading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchData();
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('id');
    });
  }

  void fetchData() async {
    var url = Uri.parse('http://localhost:8080/api/events/get/${widget.eventId}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          event = Event.fromJson(jsonDecode(response.body));
          isLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerToEvent() async {
    var url = Uri.parse('http://localhost:8080/api/participants/registerToAnEvent');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'eventId': int.parse(widget.eventId),
          'role': 'PARTICIPANT',
        }),
      );
      if (response.statusCode == 200) {
        _showTransactionResultDialog(context, 'Congratulations! Your registration was successful.');
      } else {
        _showTransactionResultDialog(context, 'Failed to register. Not enough balance.');
      }
    } catch (e) {
      _showTransactionResultDialog(context, 'An error occurred during registration.');
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : event == null
          ? Center(child: Text('No event data available.'))
          : buildEventDetails(),
    );
  }

  Widget buildEventDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event!.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 16.0),
          _buildDetailRow('Description', event!.description),
          _buildDetailRow('Location', event!.place ?? 'Not specified'),
          _buildDetailRow('Start Time', _formatDateTime(event!.startTime)),
          _buildDetailRow('End Time', _formatDateTime(event!.endTime)),
          _buildDetailRow('Type', event!.type ?? 'Not specified'),
          _buildDetailRow('Cost', '\$${event!.cost}'),
          SizedBox(height: 24.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _showConfirmationDialog(context);
              },
              child: Text('Register'),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(value),
        Divider(color: Colors.grey),
        SizedBox(height: 16.0),
      ],
    );
  }
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return '${_getMonthAbbreviation(dateTime.month)} ${dateTime.day}, ${dateTime.hour}:${dateTime.minute}';
  }
  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Are you sure you want to pay \$${event!.cost.toString()} to register for this event?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the confirmation dialog
                registerToEvent(); // Trigger the registration process
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showTransactionResultDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}



