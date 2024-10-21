import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Client {
  String id;
  String firstname;
  String lastname;
  String mobileno;
  String email;
  String address;
  String username;
  String role;
  String createdAt;

  Client({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.mobileno,
    required this.email,
    required this.address,
    required this.username,
    required this.role,
    required this.createdAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'] ?? '',
      mobileno: json['mobileno'],
      email: json['email'],
      address: json['address'] ?? '',
      username: json['username'],
      role: json['role'],
      createdAt: json['created_at'],
    );
  }
}

class ClientController extends GetxController {
  var clientList = <Client>[].obs;
  var isLoading = true.obs;

  // Fetch client data from the API
  Future<void> fetchClients() async {
    try {
      isLoading(true);
      final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-all.php';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 1) {
          clientList.value = List<Client>.from(
            data['data'].map((client) => Client.fromJson(client)),
          );
        } else {
          Get.snackbar('Error', 'No clients found');
        }
      } else {
        Get.snackbar('Error', 'Failed to load clients');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
