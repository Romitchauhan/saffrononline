import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_services.dart';

class BalanceTransferClientPage extends StatefulWidget {
  @override
  _BalanceTransferClientPageState createState() => _BalanceTransferClientPageState();
}

class _BalanceTransferClientPageState extends State<BalanceTransferClientPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rechargeIdController = TextEditingController();

  String _rechargeType = 'Online'; // Default recharge type
  bool _isLoading = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balance Transfer - Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Mobile number input
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Client Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the mobile number';
                  }
                  return null;
                },
              ),

              // Recharge amount input
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Recharge Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recharge amount';
                  }
                  return null;
                },
              ),

              // Recharge type dropdown
              DropdownButtonFormField<String>(
                value: _rechargeType,
                decoration: InputDecoration(labelText: 'Recharge Type'),
                items: ['Online', 'Offline'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _rechargeType = value!;
                  });
                },
              ),

              // Recharge ID input
              TextFormField(
                controller: _rechargeIdController,
                decoration: InputDecoration(labelText: 'Recharge ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the recharge ID';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRecharge,
                child: Text('Submit'),
              ),

              SizedBox(height: 20),

              // Display message
              if (_message != null)
                Text(
                  _message!,
                  style: TextStyle(
                    color: _message!.contains('success') ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRecharge() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final response = await ApiService.rechargeClient(
          custId: 53, // You can dynamically pass this value from UI or storage
          mobileNo: _mobileController.text,
          rechargeAmount: _amountController.text,
          rechargeDate: DateFormat('yyyy-MM-dd').format(DateTime.now()), // Get current date
          rechargeType: _rechargeType,
          rechargeId: _rechargeIdController.text,
        );

        setState(() {
          _message = response['message'];
        });
      } catch (e) {
        setState(() {
          _message = 'Recharge failed. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
