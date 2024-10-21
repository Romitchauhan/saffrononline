import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class BalanceController extends GetxController {
  var balance = 0.0.obs; // Observable balance
  var isLoading = true.obs; // Loading state

  @override
  void onInit() {
    fetchBalance();
    super.onInit();
  }

  Future<void> fetchBalance() async {
    isLoading.value = true; // Start loading
    String? userId = GetStorage().read('user_id');

    if (userId == null) {
      balance.value = 0.0; // Default balance
      isLoading.value = false;
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://saffrononline.bhavenaayurveda.com/api/check-balance.php?user_id=$userId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          balance.value = data['balance'] ?? 0.0; // Update balance
        } else {
          balance.value = 0.0; // Handle error
        }
      } else {
        balance.value = 0.0; // Handle error
      }
    } catch (e) {
      print('Error fetching balance: $e');
      balance.value = 0.0; // Handle exception
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
}
