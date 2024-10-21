import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class UpdateClientPage extends StatefulWidget {
  @override
  _UpdateClientPageState createState() => _UpdateClientPageState();
}

class _UpdateClientPageState extends State<UpdateClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Function to update client data via API
  Future<void> updateClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-update.php';
    final Map<String, dynamic> body = {
      'client_id': _clientIdController.text,
      'firstname': _firstNameController.text,
      'lastname': _lastNameController.text,
      'mobileno': _mobileController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 1) {
        Get.snackbar('Success', 'Client details updated successfully');
        // Optionally, clear the input fields after a successful update
        _clearFields();
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to update client');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void _clearFields() {
    _clientIdController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Client',style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _clientIdController,
                decoration: InputDecoration(labelText: 'Client ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Client ID is required' : null,
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'First name is required' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Mobile number is required' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Username is required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Password is required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateClient,
                child: Text('Update Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
