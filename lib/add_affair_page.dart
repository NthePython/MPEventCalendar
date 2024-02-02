import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class EventForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventFormPage(),
    );
  }
}

class EventFormPage extends StatefulWidget {
  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  double? _cost;
  String? _selectedType;

  List<String> _eventTypes = ['OFFLINE', 'ONLINE', 'HYBRID'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 5,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _placeController,
                decoration: InputDecoration(labelText: 'Place'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter event place';
                  }
                  return null;
                },
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: _startDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Start Date',
                timeLabelText: 'Start Time',
                onChanged: (dateTime) =>
                    setState(() => _startDate = DateTime.parse(dateTime!)),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: _endDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'End Date',
                timeLabelText: 'End Time',
                onChanged: (dateTime) =>
                    setState(() => _endDate = DateTime.parse(dateTime!)),
                //           DateTime _startDate = DateTime.now();
                //       DateTime _endDate = DateTime.now();
                //   DateTimePicker(
                //   type: DateTimePickerType.dateTimeSeparate,
                //   dateMask: 'yyyy-MM-dd',
                //   initialValue: DateTime.now().toString(),
                //   firstDate: DateTime(2000),
                //   lastDate: DateTime(2100),
                //   icon: Icon(Icons.event),
                //   onChanged: (val) {
                //     print(val);
                //     setState(() {
                //       _startDate = DateTime.parse(val);
                //     });
                //   },
                //   validator: (val) {
                //     if (_endDate.isBefore(_startDate)) {
                //       return 'End time cannot be before start time';
                //     }
                //     return null;
                //   },
                //   onSaved: (val) {
                //     print(val);
                //   },
                // ),
              ),
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Cost'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _cost = double.parse(value);
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _eventTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Event Type'),
                validator: (_selectedType) {
                  if (_selectedType!.isEmpty) {
                    return 'Please select event type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/home');
                    _submitForm();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Assuming allDay and eventType have been handled in your form
      bool allDay = false; // This could be another field in your form
      String? eventType = _selectedType; // If this is nullable in your API

      // Construct the JSON object with the event data
      final Map<String, dynamic> eventData = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "place": _placeController.text.isNotEmpty ? _placeController.text : null, // Assuming 'place' can be null in your API
        "startTime": _startDate.toIso8601String(),
        "endTime": _endDate.toIso8601String(),
        "cost": _cost,
        "place": _placeController.text.isNotEmpty ? _placeController.text : null, // Assuming 'place' can be null in your API
        "eventType": _selectedType,
        "allDay" : false
      };

      // Convert event data to JSON string
      String jsonEvent = jsonEncode(eventData);

      // Use the correct endpoint for adding an event
      var url = Uri.parse('http://localhost:8080/api/events/save');

      try {
        // Send the request to the API
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEvent,
        );

        // Check the response status code
        if (response.statusCode == 200 || response.statusCode == 201) {
          // If the event was added successfully, navigate to the main page
          Navigator.pushNamed(context, '/mainPage');
        } else {
          // If the server did not return a "200 OK response",
          // then throw an exception.
          throw Exception('Failed to add event');
        }
      } catch (e) {
        // Handle any exceptions here
        print(e);
      }
    }
  }

}
