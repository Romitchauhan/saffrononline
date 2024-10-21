import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class AddClientPage extends StatelessWidget {
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _mobilenoController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Function to add client via API
  Future<void> addClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-add.php';
    final Map<String, dynamic> body = {
      'firstname': _firstnameController.text,
      'lastname': _lastnameController.text,
      'mobileno': _mobilenoController.text,
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
        Get.snackbar('Success', data['message']);
        clearForm();
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to add client');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void clearForm() {
    _firstnameController.clear();
    _lastnameController.clear();
    _mobilenoController.clear();
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Client',style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstnameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'Please enter first name' : null,
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Please enter last name' : null,
              ),
              TextFormField(
                controller: _mobilenoController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Please enter mobile number' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value!.isEmpty ? 'Please enter username' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please enter password' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addClient,
                child: Text('Add Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
