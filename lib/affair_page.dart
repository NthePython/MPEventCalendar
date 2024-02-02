import 'package:flutter/material.dart';

class AffairPage extends StatelessWidget {
  final String affairName;
  final String description;
  final String location;
  final DateTime? startTime;
  final DateTime? endTime;
  final String affairType;
  final double cost;

  AffairPage({
    required this.affairName,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.affairType,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Affair Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              affairName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),

            SizedBox(height: 16.0),
            _buildDetailRow('Description', description),
            _buildDetailRow('Location', location),
            _buildDetailRow('Start Time', _formatDateTime(startTime)),
            _buildDetailRow('End Time', _formatDateTime(endTime)),
            _buildDetailRow('Affair Type', affairType),
            _buildDetailRow('Cost', '\$$cost'),

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
              'Are you sure to pay \$${cost.toString()} in order to register for this affair?'
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);//Close
              },
              child: Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(context);//Close
                _showTransactionResultDialog(context);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showTransactionResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Result'),
          content: Text('Your transaction was successful.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);//Close
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}