import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

final AuthService authService = AuthService();

class AuthController extends GetxController {
  final String loginUrl = 'https://saffrononline.bhavenaayurveda.com/api/login.php';
  final GetStorage storage = GetStorage();
  var isLoggedIn = false.obs;

  Future<void> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          // Store user data in GetStorage
          storage.write('user_id', responseData['data']['id']);
          storage.write('username', responseData['data']['username']);
          storage.write('firstname', responseData['data']['firstname']);
          storage.write('lastname', responseData['data']['lastname']);
          storage.write('mobileno', responseData['data']['mobileno']);
          storage.write('email', responseData['data']['email']);
          storage.write('address', responseData['data']['address']);
          storage.write('role', responseData['data']['role']);

          isLoggedIn.value = true; // Update login status
          Get.snackbar('Success', 'Login Successfully', snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', responseData['message'], snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        Get.snackbar('Error', 'Failed to log in. Server error: ${response.body}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An exception occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    isLoggedIn.value = true;
    await authService.verifyOtp(phoneNumber, otp);
    isLoggedIn.value = false;
  }

  void logout() {
    isLoggedIn.value = false; // Simulate logout
  }
}
