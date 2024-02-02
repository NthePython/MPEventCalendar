import 'package:flutter/material.dart';
import 'modules.dart';
import 'add_affair_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpcomingEventsPage extends StatefulWidget {
  @override
  _UpcomingEventsPageState createState() => _UpcomingEventsPageState();
}

class _UpcomingEventsPageState extends State<UpcomingEventsPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('http://localhost:8080/api/participants/getByUserId/${prefs.getInt('id')}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Participant> participants = data.map((json) => Participant.fromJson(json)).toList();
        await getEvents(participants);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> getEvents(List<Participant> participants) async {
    List<Event> fetchedEvents = [];
    for (var participant in participants) {
      var url = Uri.parse('http://localhost:8080/api/events/get/${participant.eventId}');
      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          fetchedEvents.add(Event.fromJson(data));
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    setState(() {
      events = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming Events'),
      ),
      body: _buildUpcomingEventsList(),
    );
  }

  Widget _buildUpcomingEventsList() {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.name ?? 'Event ${index + 1}'),
          subtitle: Text('Date: ${event.startTime ?? 'DD/MM/YYYY'}'),
          onTap: () {
            // Handle your tap here.
          },
        );
      },
    );
  }
}
