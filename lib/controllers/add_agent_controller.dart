import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAgentController extends GetxController {
  var isLoading = false.obs;

  // Input field controllers
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController mobilenoController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Error messages
  var firstnameError = ''.obs;
  var lastnameError = ''.obs;
  var mobilenoError = ''.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;

  // Validate input fields
  bool validateFields() {
    bool isValid = true;

    if (firstnameController.text.isEmpty) {
      firstnameError.value = "First name is required";
      isValid = false;
    } else {
      firstnameError.value = '';
    }

    if (lastnameController.text.isEmpty) {
      lastnameError.value = "Last name is required";
      isValid = false;
    } else {
      lastnameError.value = '';
    }

    if (mobilenoController.text.isEmpty || mobilenoController.text.length != 10) {
      mobilenoError.value = "Mobile number must be exactly 10 digits";
      isValid = false;
    } else {
      mobilenoError.value = '';
    }

    if (usernameController.text.isEmpty) {
      usernameError.value = "Username is required";
      isValid = false;
    } else {
      usernameError.value = '';
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      passwordError.value = "Password must be at least 6 characters long";
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

  // Add agent function
  Future<void> addAgent() async {
    if (!validateFields()) {
      return;
    }

    // Show loading indicator
    isLoading.value = true;

    // API URL
    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/agent-add.php';

    // Request body
    final body = {
      "firstname": firstnameController.text,
      "lastname": lastnameController.text,
      "mobileno": mobilenoController.text,
      "username": usernameController.text,
      "password": passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      final jsonResponse = json.decode(response.body);

      // Handle success response
      if (jsonResponse['status'] == 1) {
        Get.snackbar('Success', 'Agent added successfully',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.transparent, colorText: Colors.black);

        // Clear input fields
        firstnameController.clear();
        lastnameController.clear();
        mobilenoController.clear();
        usernameController.clear();
        passwordController.clear();
      } else {
        Get.snackbar('Error', jsonResponse['message'],
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.transparent, colorText: Colors.black);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add agent',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.transparent, colorText: Colors.black);
    } finally {
      // Hide loading indicator
      isLoading.value = false;
    }
  }
}
