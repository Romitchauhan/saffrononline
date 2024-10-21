import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../controllers/agent_details_controller.dart';
import '../../utils/app_color.dart';

class AgentDetailsScreen extends StatelessWidget {
  final AgentDetailsController controller = Get.put(AgentDetailsController());

  // Constructor to accept agentId dynamically
  AgentDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lock the orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Fetch agent details using the dynamic agent ID
    final String? agentId = Get.arguments != null && Get.arguments is Map
        ? Get.arguments['agentId']
        : null;

    if (agentId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Agent Details",style: TextStyle(color: Colors.white),),
            backgroundColor: AppColors.main,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Center(child: Text("Error: agentId not provided")),
      );
    }

    // Call the method to fetch agent details using the agentId
    controller.fetchAgentDetails(agentId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Agent Details"),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(controller.firstnameController, 'First Name'),
                SizedBox(height: 16),
                _buildTextField(controller.lastnameController, 'Last Name'),
                SizedBox(height: 16),
                _buildTextField(
                    controller.mobilenoController, 'Mobile Number',
                    keyboardType: TextInputType.phone),
                SizedBox(height: 16),
                _buildTextField(controller.usernameController, 'Username'),
                SizedBox(height: 16),
                _buildTextField(controller.passwordController, 'Password',
                    obscureText: true),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (controller.validateFields()) {
                      // Perform save or update actions
                      Get.snackbar('Success', 'Validation passed!',
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Update Details',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Reusable TextField widget
  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      ),
    );
  }
}
