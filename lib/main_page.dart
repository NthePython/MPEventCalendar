import 'package:flutter/material.dart';
import 'modules.dart';
import 'add_affair_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _filterApplied = false;
  double balance = 0;
  List<Event> events = [];
  User? thisUser;
  void initState() {
    super.initState();
    fetchData();
    getBalance();
  }

  void getBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = Uri.parse('http://localhost:8080/api/users/get/${prefs.getInt('id')}');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          thisUser = User.fromJson(data);
          balance = thisUser?.balance ?? 0;
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchData() async {
    var url = Uri.parse('http://localhost:8080/api/events/get');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          events = data.map((json) => Event.fromJson(json)).toList();
        });
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Event> getFilteredEvents(List<Event> events) {
    if (_filterApplied) {
      return events.where((event) => (event.cost == 0 || event.cost.isNaN)).toList();
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    List<Event> filteredEvents = getFilteredEvents(events);

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Management and Registration'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          IconButton(
              onPressed: (){Navigator.pushNamed(context, '/upcoming');},
              icon: Icon(Icons.calendar_month_outlined)
          ),
          IconButton(
            icon: Icon(_filterApplied ? Icons.filter_alt : Icons.filter_alt_off),
            onPressed: () {
              setState(() {
                _filterApplied = !_filterApplied;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to the Event Management and Registration Page!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Balance: \$${balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return EventWidget(
                  id: event.id,
                  name: event.name,
                  description: event.description,
                  place: event.place,
                  startTime: event.startTime,
                  endTime: event.endTime,
                  cost: event.cost,
                  type: event.type,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addForm');
        },
      ),
    );
  }
}
