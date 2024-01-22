import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AffairForm extends StatelessWidget {
  const AffairForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Affair Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AffairFormPage(),
    );
  }
}

class AffairFormPage extends StatefulWidget {
  @override
  _AffairFormPageState createState() => _AffairFormPageState();
}

class _AffairFormPageState extends State<AffairFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  double? _cost;
  String? _selectedType;
  final List<String> _affairTypes = ['Offline', 'Online', 'Hybrid'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Affair'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
              TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Affair Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the affair name';
                }
                return null;
              },
            ),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the description';
                }
                return null;
              },
            ),

            TextFormField(
              controller: _placeController,
              decoration: const InputDecoration(labelText: 'Place'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the affair place';
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
                  setState(() => _startDate = DateTime.parse(dateTime)),
            ),

            DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                initialValue: _endDate.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'End Date',
                timeLabelText: 'End Time',
                onChanged: (dateTime) =>
                    setState(() => _endDate = DateTime.parse(dateTime)),
              ),

              TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Cost'),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _cost = double.parse(value);
                  }
                },
              ),

              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _affairTypes.map((String type) {
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
                decoration: const InputDecoration(labelText: 'Affair Type'),
                validator: (selectedType) {
                  if (selectedType!.isEmpty) {
                    return 'Please select affair type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/home');
                    _submitForm();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    print('Affair Name: ${_nameController.text}');
    print('Description: ${_descriptionController.text}');
    print('Place: ${_placeController.text}');
    print('Start Time: $_startDate');
    print('End Time: $_endDate');
    print('Cost: $_cost');
    print('Affair Type: $_selectedType');
  }
}
