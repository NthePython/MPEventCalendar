import 'package:flutter/material.dart';

class UpcomingEventsPage extends StatelessWidget {
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
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Event ${index + 1}'),
          subtitle: Text('Date: DD/MM/YYYY'),
          onTap: () {
          },
        );
      },
    );
  }
}
