import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AgentDetailsController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Define text controllers for the fields
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Simulating an agent details fetch
  void fetchAgentDetails(String agentId) async {
    try {
      isLoading(true);
      errorMessage('');

      // Simulate a delay for fetching details (replace this with your API call)
      await Future.delayed(Duration(seconds: 2));

      // After fetching, populate the text fields with the data
      firstnameController.text = 'John';
      lastnameController.text = 'Doe';
      mobilenoController.text = '1234567890';
      usernameController.text = 'johndoe';
      passwordController.text = 'password123';

      // On success, you would typically set the values from the API response
    } catch (e) {
      errorMessage('Failed to fetch agent details. Please try again.');
    } finally {
      isLoading(false);
    }
  }

  // Field validation function
  bool validateFields() {
    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        mobilenoController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      errorMessage('Please fill in all fields.');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    // Dispose controllers when not in use
    firstnameController.dispose();
    lastnameController.dispose();
    mobilenoController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
