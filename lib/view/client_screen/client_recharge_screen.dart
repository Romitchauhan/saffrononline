import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class ClientRechargePage extends StatefulWidget {
  @override
  _ClientRechargePageState createState() => _ClientRechargePageState();
}

class _ClientRechargePageState extends State<ClientRechargePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _custIdController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _rechargeAmountController = TextEditingController();
  final TextEditingController _rechargeDateController = TextEditingController();
  String _rechargeType = 'Online'; // default value

  // Function to add client recharge via API
  Future<void> addClientRecharge() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-recharge.php';
    final Map<String, dynamic> body = {
      'cust_id': _custIdController.text,
      'mobileno': _mobileNoController.text,
      'recharge_amount': _rechargeAmountController.text,
      'recharge_date': _rechargeDateController.text,
      'recharge_type': _rechargeType,
      'recharge_id': '' // Assuming recharge_id is auto-generated or optional
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 1) {
        Get.snackbar('Success', 'Points added successfully');
        _clearFields(); // Clear form fields after successful recharge
      } else {
        Get.snackbar('Error', data['message'] ?? 'Recharge failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Clear input fields
  void _clearFields() {
    _custIdController.clear();
    _mobileNoController.clear();
    _rechargeAmountController.clear();
    _rechargeDateController.clear();
    setState(() {
      _rechargeType = 'Online'; // Reset to default value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Recharge',style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Client ID
              TextFormField(
                controller: _custIdController,
                decoration: InputDecoration(labelText: 'Client ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Client ID is required' : null,
              ),
              SizedBox(height: 16),

              // Mobile Number
              TextFormField(
                controller: _mobileNoController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Mobile number is required' : null,
              ),
              SizedBox(height: 16),

              // Recharge Amount
              TextFormField(
                controller: _rechargeAmountController,
                decoration: InputDecoration(labelText: 'Recharge Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Recharge amount is required' : null,
              ),
              SizedBox(height: 16),

              // Recharge Date
              TextFormField(
                controller: _rechargeDateController,
                decoration: InputDecoration(labelText: 'Recharge Date (YYYY-MM-DD)'),
                keyboardType: TextInputType.datetime,
                validator: (value) => value!.isEmpty ? 'Recharge date is required' : null,
              ),
              SizedBox(height: 16),

              // Recharge Type
              DropdownButtonFormField<String>(
                value: _rechargeType,
                items: ['Online', 'Cash'].map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _rechargeType = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Recharge Type'),
              ),
              SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: addClientRecharge,
                child: Text('Add Recharge'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
