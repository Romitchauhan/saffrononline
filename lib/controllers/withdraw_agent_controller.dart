import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON responses

class WithdrawAgentController extends GetxController {
  // Form fields
  var agentId = ''.obs;
  var mobileNo = ''.obs;
  var withdrawAmount = ''.obs;
  var withdrawDate = ''.obs;
  var withdrawType = ''.obs;

  // Method to pick date
  void pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      withdrawDate.value = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  // API call method
  Future<void> withdrawPoints() async {
    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/agent-withdraw.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'agent_id': agentId.value,
        'mobileno': mobileNo.value,
        'withdraw_amount': withdrawAmount.value,
        'withdraw_date': withdrawDate.value,
        'withdraw_type': withdrawType.value,
        'withdraw_id': '', // Empty as per API requirement
      }),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result['status'] == 1) {
        Get.snackbar("Success", "Points withdrawn successfully", snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", result['message'], snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar("Error", "Failed to withdraw points", snackPosition: SnackPosition.BOTTOM);
    }
  }
}

