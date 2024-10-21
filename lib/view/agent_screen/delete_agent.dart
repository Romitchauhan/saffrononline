import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/app_color.dart';

class DeleteAgentScreen extends StatefulWidget {
  @override
  _DeleteAgentScreenState createState() => _DeleteAgentScreenState();
}

class _DeleteAgentScreenState extends State<DeleteAgentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _agentIdController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _deleteAgent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String apiUrl =
          'https://saffrononline.bhavenaayurveda.com/api/admin/agent-delete.php';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode({'agent_id': _agentIdController.text}),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          setState(() {
            _message = responseData['message'];
          });
          _showSuccessDialog('Success', _message ?? 'Agent deleted successfully');
        } else {
          setState(() {
            _message = responseData['message'] ?? 'Something went wrong';
          });
          _showErrorDialog('Error', _message!);
        }
      } else {
        _showErrorDialog('Error', 'Failed to delete agent.');
      }
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Agent',style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _agentIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Agent ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Agent ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _deleteAgent,
                child: Text('Delete Agent'),
              ),
              if (_message != null) ...[
                SizedBox(height: 20),
                Text(
                  _message!,
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
