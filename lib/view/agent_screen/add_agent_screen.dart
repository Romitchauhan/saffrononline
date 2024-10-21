import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:saffrononline/utils/app_color.dart';
import '../../controllers/add_agent_controller.dart';

class AddAgentScreen extends StatefulWidget {
  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  final AddAgentController controller = Get.put(AddAgentController());

  @override
  Widget build(BuildContext context) {
    // Lock screen orientation to portrait when entering this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return WillPopScope(
      onWillPop: () async {
        // Reset the orientation when leaving this screen
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Agent", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.main,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Obx(() => _buildTextField(
                  controller.firstnameController,
                  'First Name',
                  errorText: controller.firstnameError.value,
                )),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                  controller.lastnameController,
                  'Last Name',
                  errorText: controller.lastnameError.value,
                )),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                  controller.mobilenoController,
                  'Mobile Number',
                  keyboardType: TextInputType.phone,
                  errorText: controller.mobilenoError.value,
                )),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                  controller.usernameController,
                  'Username',
                  errorText: controller.usernameError.value,
                )),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                  controller.passwordController,
                  'Password',
                  obscureText: true,
                  errorText: controller.passwordError.value,
                )),
                SizedBox(height: 30),
                Obx(() => controller.isLoading.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    // Validate fields and add agent
                    controller.addAgent();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Dark blue
                  ),
                  child: Text(
                    'Add Agent',
                    style: TextStyle(fontSize: 18,),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text field widget with common styling and error message support
  Widget _buildTextField(
      TextEditingController controller, String hintText,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text, String? errorText}) {
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
        errorText: errorText?.isNotEmpty == true ? errorText : null, // Display error message in one place
      ),
    );
  }
}
