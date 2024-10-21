import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class HistoryController extends GetxController {
  var selectedFromDate = DateTime.now().obs;
  var selectedToDate = DateTime.now().obs;
  var isLoading = false.obs;
  var historyList = [].obs;
  final box = GetStorage();// List to store the history data

  // Function to pick 'From' date
  Future<void> pickFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedFromDate.value) {
      selectedFromDate.value = picked;
    }
  }

  // Function to pick 'To' date
  Future<void> pickToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedToDate.value) {
      selectedToDate.value = picked;
    }
  }

  // Function to fetch history
  Future<void> fetchHistory() async {
    isLoading.value = true;

    try {
      final userId = box.read('user_id');
      // Define the API endpoint
      final url = 'https://saffrononline.bhavenaayurveda.com/api/purchase-history.php';

      // Define the request body
      var body = jsonEncode({
        'user_id': userId.toString(), // Replace with dynamic user ID if needed
        'from_date': DateFormat('yyyy-MM-dd').format(selectedFromDate.value),
        'to_date': DateFormat('yyyy-MM-dd').format(selectedToDate.value),
      });

      // Send POST request to the API
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Check if the response status is OK
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1 && data['data'] != null && data['data'].isNotEmpty) {
          // If successful, store the history data
          historyList.value = data['data'].map((item) {
            if (item['point_data'] != null && item['point_data'].isNotEmpty) {
              var pointData = item['point_data'][0]; // Safely access first point_data
              return {

                'yantra_name': pointData['yantra_name'] ?? 'Unknown',
                'points': pointData['yantra_point'] ?? '0',
                'date': item['created_at'] ?? 'Unknown date',

              };
            }
            return null; // Return null if no point_data is found
          }).where((element) => element != null).toList(); // Remove null values
        } else {
          // Handle the case where there's no data or an error
          historyList.value = [];
          Get.snackbar('No Data', 'No history available for this date range.');
        }
      } else {
        // Handle errors
        Get.snackbar('Error', 'Failed to fetch history. Please try again.');
      }
    } catch (e) {
      // Handle any exceptions
      Get.snackbar('Error', 'An error occurred: $e');
      print("Error-------------------------------------------$e");
    } finally {
      isLoading.value = false;
    }
  }
}
