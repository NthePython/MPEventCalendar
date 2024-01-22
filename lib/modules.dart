import 'package:flutter/material.dart';
import 'affair_page.dart';

class AffairWidget extends StatelessWidget {
  final String? name;
  final String? description;
  final String? place;
  final DateTime? startTime;
  final DateTime? endTime;
  final double? cost;
  final String? type;

  const AffairWidget({
    Key? key,
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
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),

            SizedBox(height: 8.0),
            Row(
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
                    Text('Start Time: ${_formatDateTime(startTime)}'),
                    SizedBox(height: 8.0),
                    Text('End Time: ${_formatDateTime(endTime)}'),
                  ],
                ),
              ],
            ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Cost: \$${cost ?? 0.0}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),

            SizedBox(height: 8.0),
            Text(
              'Type: ${type ?? ''}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to EventPage and pass event details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AffairPage(
                          affairName: name ?? '',
                          description: description ?? '',
                          location: place ?? '',
                          startTime: startTime,
                          endTime: endTime,
                          affairType: type ?? '',
                          cost: cost ?? 0.0,
                        ),
                      ),
                    );
                  },
                  child: Text('More >>'),
                ),
              ],
            ),
          ],
        ),
      ),
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
}

// import 'package:flutter/material.dart';
//
// class EventWidget extends StatelessWidget {
//   final String name;
//   final String description;
//   final String place;
//   final DateTime startTime;
//   final DateTime endTime;
//   final double cost;
//   final String type;
//
//   const EventWidget({
//     Key? key,
//     required this.name,
//     required this.description,
//     required this.place,
//     required this.startTime,
//     required this.endTime,
//     required this.cost,
//     required this.type,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.amberAccent,
//       child: Container(
//         padding: EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.redAccent),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               name,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18.0,
//               ),
//             ),
//             SizedBox(height: 8.0),
//             Text(description),
//             SizedBox(height: 8.0),
//             Text('Location: $place'),
//             SizedBox(height: 8.0),
//             Text('Start Time: ${startTime.toString()}'),
//             SizedBox(height: 8.0),
//             Text('End Time: ${endTime.toString()}'),
//             SizedBox(height: 8.0),
//             Text('Cost: \$$cost'),
//             SizedBox(height: 8.0),
//             Text('Type: $type'),
//           ],
//         ),
//       ),
//     );
//   }
// }
