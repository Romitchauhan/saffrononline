import 'dart:io';

import 'package:flutter/material.dart';

class AddYantraScreen extends StatefulWidget {
  @override
  _AddYantraScreenState createState() => _AddYantraScreenState();
}

class _AddYantraScreenState extends State<AddYantraScreen> {
  final _formKey = GlobalKey<FormState>();
  String? yantraName, date, time;
  int? yantraPrice;
  File? yantraImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Add Yantra')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Yantra Name'),
                  onSaved: (value) => yantraName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => yantraPrice = int.tryParse(value ?? '0'),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date'),
                  onSaved: (value) => date = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Time'),
                  onSaved: (value) => time = value,
                ),
                // Image picker for yantra image (use image_picker package)
                ElevatedButton(
                  onPressed: () => _submitForm(),
                  child: Text('Add Yantra'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    _formKey.currentState?.save();
    // Call the add yantra API
  }
}
