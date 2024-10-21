import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PurchaseHistoryController extends GetxController {
  var purchaseHistory = [].obs;
  var isLoading = false.obs; // Default value to false
  var error = ''.obs;

  Future<void> fetchPurchaseHistory(String userId) async {
    try {
      isLoading(true);
      var url = 'https://saffrononline.bhavenaayurveda.com/api/admin/purchase-history.php';
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'user_id': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 1) {
        purchaseHistory.value = jsonData['data']; // Populate the data on success
        error.value = '';
      } else {
        error.value = jsonData['message'] ?? 'An error occurred';
        purchaseHistory.clear();
      }
    } catch (e) {
      error.value = 'Failed to fetch data';
      purchaseHistory.clear();
    } finally {
      isLoading(false); // Always set isLoading to false when done
    }
  }
  void resetState() {
    isLoading.value = false;
    error.value = '';
    purchaseHistory.clear(); // Clear previous history
  }
}
