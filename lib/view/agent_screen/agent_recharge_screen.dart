import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../utils/app_color.dart';

class AgentRechargeScreen extends StatefulWidget {
  @override
  _AgentRechargeScreenState createState() => _AgentRechargeScreenState();
}

class _AgentRechargeScreenState extends State<AgentRechargeScreen> {
  final TextEditingController _agentIdController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _rechargeAmountController = TextEditingController();
  final TextEditingController _rechargeDateController = TextEditingController();
  final TextEditingController _rechargeTypeController = TextEditingController();
  final TextEditingController _rechargeIdController = TextEditingController();
  String _message = '';

  Future<void> addAgentRecharge() async {
    if (_agentIdController.text.isEmpty ||
        _mobileNoController.text.isEmpty ||
        _rechargeAmountController.text.isEmpty ||
        _rechargeDateController.text.isEmpty ||
        _rechargeTypeController.text.isEmpty ||
        _rechargeIdController.text.isEmpty) {
      setState(() {
        _message = 'Please fill in all fields';
      });
      return;
    }

    final Map<String, dynamic> requestData = {
      "agent_id": int.parse(_agentIdController.text),
      "mobileno": _mobileNoController.text,
      "recharge_amount": _rechargeAmountController.text,
      "recharge_date": _rechargeDateController.text,
      "recharge_type": _rechargeTypeController.text,
      "recharge_id": _rechargeIdController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://saffrononline.bhavenaayurveda.com/api/admin/agent-recharge.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestData),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 1) {
        setState(() {
          _message = responseData['message'];
        });
      } else {
        setState(() {
          _message = responseData['message'] ?? 'Failed to recharge';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'An error occurred: $e';
      });
    }
  }

  @override
  void dispose() {
    _agentIdController.dispose();
    _mobileNoController.dispose();
    _rechargeAmountController.dispose();
    _rechargeDateController.dispose();
    _rechargeTypeController.dispose();
    _rechargeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agent Recharge',style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(  // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _agentIdController,
              decoration: InputDecoration(labelText: 'Agent ID'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _mobileNoController,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _rechargeAmountController,
              decoration: InputDecoration(labelText: 'Recharge Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _rechargeDateController,
              decoration: InputDecoration(labelText: 'Recharge Date (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              controller: _rechargeTypeController,
              decoration: InputDecoration(labelText: 'Recharge Type'),
            ),
            TextField(
              controller: _rechargeIdController,
              decoration: InputDecoration(labelText: 'Recharge ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addAgentRecharge,
              child: Text('Submit Recharge'),
            ),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
