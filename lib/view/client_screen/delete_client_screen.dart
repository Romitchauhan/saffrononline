import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class DeleteClientPage extends StatefulWidget {
  @override
  _DeleteClientPageState createState() => _DeleteClientPageState();
}

class _DeleteClientPageState extends State<DeleteClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();

  // Function to delete client via API
  Future<void> deleteClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-delete.php';
    final Map<String, dynamic> body = {
      'client_id': _clientIdController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 1) {
        Get.snackbar('Success', 'Client deleted successfully');
        _clientIdController.clear(); // Optionally clear input after successful delete
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to delete client');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delete Client',style: TextStyle(color: Colors.white)),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: deleteClient,
                child: Text('Delete Client'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
