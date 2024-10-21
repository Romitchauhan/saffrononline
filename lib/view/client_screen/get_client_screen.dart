import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class GetClientPage extends StatefulWidget {
  @override
  _GetClientPageState createState() => _GetClientPageState();
}

class _GetClientPageState extends State<GetClientPage> {
  final _clientIdController = TextEditingController();
  Map<String, dynamic>? clientData;
  final _formKey = GlobalKey<FormState>();

  // Function to get client data via API
  Future<void> getClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-get.php';
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
        setState(() {
          clientData = data['data'];
        });
        Get.snackbar('Success', 'Client data retrieved successfully');
      } else {
        Get.snackbar('Error', data['message'] ?? 'Failed to retrieve client data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Get Client',style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _clientIdController,
                decoration: InputDecoration(labelText: 'Enter Client ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter client ID' : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: getClient,
              child: Text('Get Client'),
            ),
            SizedBox(height: 20),
            if (clientData != null)
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('First Name'),
                      subtitle: Text(clientData!['firstname'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Last Name'),
                      subtitle: Text(clientData!['lastname'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Mobile Number'),
                      subtitle: Text(clientData!['mobileno'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Email'),
                      subtitle: Text(clientData!['email'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Username'),
                      subtitle: Text(clientData!['username'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Role'),
                      subtitle: Text(clientData!['role'] ?? 'N/A'),
                    ),
                    ListTile(
                      title: Text('Created At'),
                      subtitle: Text(clientData!['created_at'] ?? 'N/A'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
