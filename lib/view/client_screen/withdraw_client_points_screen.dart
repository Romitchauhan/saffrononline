import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class WithdrawClientPointsPage extends StatefulWidget {
  @override
  _WithdrawClientPointsPageState createState() => _WithdrawClientPointsPageState();
}

class _WithdrawClientPointsPageState extends State<WithdrawClientPointsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _custIdController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _withdrawAmountController = TextEditingController();
  final TextEditingController _withdrawDateController = TextEditingController();
  String _withdrawType = 'Cash'; // Default value for withdrawal type

  // Function to handle the withdrawal process
  Future<void> withdrawClientPoints() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if form is not valid
    }

    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-withdraw.php';
    final Map<String, dynamic> body = {
      'cust_id': _custIdController.text,
      'mobileno': _mobileNoController.text,
      'withdraw_amount': _withdrawAmountController.text,
      'withdraw_date': _withdrawDateController.text,
      'withdraw_type': _withdrawType,
      'withdraw_id': ''
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 1) {
        Get.snackbar('Success', 'Points withdrawn successfully');
        _clearFields(); // Clear fields after successful withdrawal
      } else {
        Get.snackbar('Error', data['message'] ?? 'Withdrawal failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Clear form fields after successful submission
  void _clearFields() {
    _custIdController.clear();
    _mobileNoController.clear();
    _withdrawAmountController.clear();
    _withdrawDateController.clear();
    setState(() {
      _withdrawType = 'Cash'; // Reset to default
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw Client Points',style: TextStyle(color: Colors.white)),
        //centerTitle: true,
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Client ID
              TextFormField(
                controller: _custIdController,
                decoration: InputDecoration(
                  labelText: 'Client ID',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Client ID is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Mobile Number
              TextFormField(
                controller: _mobileNoController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mobile number is required';
                  } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Withdraw Amount
              TextFormField(
                controller: _withdrawAmountController,
                decoration: InputDecoration(
                  labelText: 'Withdraw Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Withdraw amount is required';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Withdraw Date
              TextFormField(
                controller: _withdrawDateController,
                decoration: InputDecoration(
                  labelText: 'Withdraw Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Withdraw date is required';
                  } else if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    return 'Enter a valid date (YYYY-MM-DD)';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Withdraw Type
              DropdownButtonFormField<String>(
                value: _withdrawType,
                decoration: InputDecoration(
                  labelText: 'Withdraw Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Cash', 'Online'].map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _withdrawType = newValue!;
                  });
                },
              ),
              SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: withdrawClientPoints,
                child: Text('Withdraw Points'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
