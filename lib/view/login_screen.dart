import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/auth_controller.dart';
import '../utils/screen_utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController(); // Combined Name/Mobile input
  final TextEditingController passwordController = TextEditingController();

  final GetStorage storage = GetStorage();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  void saveUserId(int userId) {
    final box = GetStorage();
    box.write('user_id', userId);
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


  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      String username = usernameController.text;
      String password = passwordController.text;

      try {
        final response = await http.post(
          Uri.parse('https://saffrononline.bhavenaayurveda.com/api/login.php'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);

          // Check if login was successful
          if (data['status'] == 1) {
            // Call saveUserData here to store the first name and ID
            saveUserData(data['data']); // Pass the 'data' section of the response

            // Check the role and redirect accordingly
            String role = data['data']['role'];
            if (role == 'customer') {
              Get.offAndToNamed('/home'); // Redirect to home screen for client
            } else if (role == 'agent') {
              Get.offAndToNamed('/agent'); // Redirect to agent home screen
            } else if (role == 'admin') {
              Get.offAndToNamed('/super_admin'); // Redirect to agent home screen
            } else {
              Get.snackbar('Error', 'Unknown role'); // Handle unexpected role
            }

            // Log the user in
            authController.login(username, password);
          } else {
            Get.snackbar('Error', data['message'] ?? 'Login failed');
          }
        } else {
          Get.snackbar('Error', 'Failed to connect to the server');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      }
    } else {
      Get.snackbar('Error', 'Please correct the errors in the form');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: ScreenUtils.getAllPadding(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: ScreenUtils.getHeight(20)),
                      Container(
                          height: ScreenUtils.getHeight(100),
                          width: ScreenUtils.getWidth(100),
                          child: Image.asset('assets/images/saffron_logo.png')),
                      SizedBox(height: ScreenUtils.getHeight(20)),
                      Text('Login', style: TextStyle(fontSize: ScreenUtils.getFontSize(30), fontWeight: FontWeight.bold)),
                      Text('Welcome To Saffron Online', style: TextStyle(fontSize: ScreenUtils.getFontSize(24), fontWeight: FontWeight.bold)),
                      SizedBox(height: ScreenUtils.getHeight(20)),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Name/Mobile',
                          labelStyle: TextStyle(fontSize: ScreenUtils.getFontSize(16)),
                        ),
                        keyboardType: TextInputType.text, // Use a generic input type since this can be name or number
                        style: TextStyle(fontSize: ScreenUtils.getFontSize(16)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name or Mobile cannot be empty';
                          }
                          // Check if it's a valid mobile number
                          if (RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                            // Input is a valid mobile number
                            return null;
                          }
                          // Input is treated as a name if it's not a number
                          return null; // Allow the name as well
                        },
                      ),
                      SizedBox(height: ScreenUtils.getHeight(10)),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: ScreenUtils.getFontSize(16)),
                        ),
                        obscureText: true,
                        style: TextStyle(fontSize: ScreenUtils.getFontSize(16)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: ScreenUtils.getHeight(20)),
                      ElevatedButton(
                        onPressed: login,
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: ScreenUtils.getFontSize(18)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: ScreenUtils.getHeight(20)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
