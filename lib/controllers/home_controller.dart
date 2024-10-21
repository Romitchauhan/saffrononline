import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../services/game_service.dart';
import 'game_controller.dart';

class HomeController extends GetxController {
  final String baseUrl = 'https://saffrononline.bhavenaayurveda.com/Admin/yantraimage/';
  final String baseUrl1 = 'https://saffrononline.bhavenaayurveda.com/api/purchase-history.php';
  var lastFiveDraws = <Draw>[].obs; // Assuming 'Draw' is a model for draw data
  RxInt balance = 0.obs; // Initial value is set to 0
  int get userId => storage.read('user_id') ?? 20; // Default to 20 if not found

  var history = <Map<String, dynamic>>[]
      .obs; // Observable list for history data
  var selectedImageIndex = (-1).obs;
  var selectedYantraPoints = <int>[]
      .obs; // List to store points for each yantra
  var selectedPoint = 0.obs;
  var rotationAngle = 0.0.obs;
  final GetStorage storage = GetStorage();
  var allDraw = <Yantra>[].obs; // Observable list for all yantras
  final List<int> pointValues = [1, 2, 5, 10, 20]; // Correct point values
  RxString currentDate = ''.obs;
  RxString currentTime = ''.obs;
  var purchaseResponseData = {}.obs; // Observable map to store the response data

  // Retrieve username from storage
  String get username => storage.read('Name') ?? '';
  RxString remainingTime = ''.obs; // Start at 5 minutes
  Timer? _timer;
  int countdownDuration = 300;

// 5 minutes in seconds


  @override
  void onInit() {
    super.onInit();
    startCountdown();
    selectedYantraPoints.assignAll(
        List.filled(10, 0)); // 10 is just an example size
    //fetchUserHistory(); // Fetch user history on init
    fetchAllDraw();
    fetchBalance();
    fetchHistory();
    setCurrentDateTime();
    // Fetch all yantras on init
  }

  // Fetch all yantras from API
  Future<void> fetchAllDraw() async {
    try {
      allDraw.value = await ApiService1().fetchAllYantras();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch yantras');
    }
  }
  void printPurchaseData() {
    print("Stored Purchase Data: ${purchaseResponseData.value}");
  }

  // Save yantra points
  void saveYantraPoints(int index, int points) {
    if (index >= 0 && index < selectedYantraPoints.length) {
      selectedYantraPoints[index] = points;
    } else {
      print('Error: Index out of range');
    }
  }

  // Select yantra and assign points
  // void selectYantra(int index) {
  //   if (index >= 0 && index < selectedYantraPoints.length) {
  //     selectedYantraPoints[index] = selectedPoint.value;
  //   } else {
  //     print('Error: Index out of range');
  //   }
  // }

  Future<void> fetchBalance() async {
    String? userId = storage.read('user_id'); // Retrieve user_id from storage

    if (userId == null) {
      Get.snackbar('Error', 'No user ID found. Please log in again.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://saffrononline.bhavenaayurveda.com/api/check-balance.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": int.tryParse(userId)}), // Convert user_id to int
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          balance.value = int.tryParse(data['data']['point'].toString()) ?? 0;
        } else {
          Get.snackbar('Error', data['message'] ?? 'Failed to fetch balance',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        print('Failed to fetch balance: ${response.body}');
        Get.snackbar('Error', 'Failed to fetch balance',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
  void saveUserData(Map<String, dynamic> userData) {
    // Ensure userData contains 'first_name' and 'user_id'
    if (userData['first_name'] != null) {
      storage.write('first_name', userData['first_name']);
    } else {
      print('First name not found in user data');
    }

    if (userData['id'] != null) {
      storage.write('id', userData['id']);
    } else {
      print('User ID not found in user data');
    }
  }



  // Clear all selections
  void clearSelections() {
    selectedImageIndex.value = -1; // Use -1 to indicate no selection
    selectedPoint.value = 0;
    rotationAngle.value = 0.0;
    selectedYantraPoints.assignAll(
        List.filled(selectedYantraPoints.length, 0)); // Reset the list
  }
  void loadFirstName() {
    String? firstName = storage.read('first_name');
    if (firstName != null) {
      print('Loaded first name: $firstName');
      // Use the first name, for example, display it in the UI
    } else {
      print('First name not found in storage');
      Get.snackbar('Error', 'First name not found. Please log in again.');
    }
  }


  // Fetch user purchase history
  void fetchHistory() async {
    String? userId = storage.read('id');
    print('User ID: $userId');

    // If userId is null, handle it gracefully
    if (userId == null) {
      Get.snackbar('Error', 'No user ID found. Please log in again.');
      return;
    }

    try {
      // Make the API call
      final response = await http.post(
        Uri.parse('https://saffrononline.bhavenaayurveda.com/api/history.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': userId, // Ensure correct key-value for body data
        }),
      );

      // Check for successful response
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Print raw response for debugging
        print('History API Response: ${response.body}');

        // Verify status key in response
        if (data['status'] == 1) {
          print('History data fetched successfully.');
          // Process and display the history data (you can parse and store it)
        } else {
          // Handle server response errors (like wrong ID or data not found)
          Get.snackbar('Error', data['message'] ?? 'Failed to retrieve history.');
        }
      } else {
        // Non-200 status code (e.g., 404, 500)
        Get.snackbar('Error', 'Failed to connect to the server. Status: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and display detailed error messages
      print('Error during API call: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }


  void setCurrentDateTime() {
    // Set the current date
    currentDate.value = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Update the current time every second
    Timer.periodic(Duration(seconds: 1), (timer) {
      currentTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
    });
  }
  void startCountdown() {
    // Timer that decrements the remaining time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int minutes = countdownDuration ~/ 60;
      int seconds = countdownDuration % 60;
      remainingTime.value = '$minutes:${seconds.toString().padLeft(2, '0')}';

      if (countdownDuration > 0) {
        countdownDuration--;
      } else {
        // Reset the countdown to 5 minutes once it reaches 0
        countdownDuration = 300;
      }
    });
  }
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

