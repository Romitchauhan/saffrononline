import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import '../../controllers/withdraw_agent_controller.dart';
import '../../utils/app_color.dart';

class WithdrawAgentPage extends StatelessWidget {
  final WithdrawAgentController controller = Get.put(WithdrawAgentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw Agent Points',style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Agent ID Input
            TextField(
              onChanged: (value) => controller.agentId.value = value,
              decoration: InputDecoration(labelText: 'Agent ID'),
            ),

            // Mobile Number Input
            TextField(
              onChanged: (value) => controller.mobileNo.value = value,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            ),

            // Withdraw Amount Input
            TextField(
              onChanged: (value) => controller.withdrawAmount.value = value,
              decoration: InputDecoration(labelText: 'Withdraw Amount'),
              keyboardType: TextInputType.number,
            ),

            // Withdraw Date Picker
            Obx(() => ListTile(
              title: Text('Withdraw Date: ${controller.withdrawDate.value.isEmpty ? 'Select Date' : controller.withdrawDate.value}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => controller.pickDate(context),
            )),

            // Withdraw Type Dropdown
            Obx(() => DropdownButton<String>(
              value: controller.withdrawType.value.isEmpty ? null : controller.withdrawType.value,
              hint: Text('Select Withdraw Type'),
              items: ['Cash', 'Bank'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                controller.withdrawType.value = value!;
              },
            )),

            SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (controller.agentId.value.isNotEmpty &&
                    controller.mobileNo.value.isNotEmpty &&
                    controller.withdrawAmount.value.isNotEmpty &&
                    controller.withdrawDate.value.isNotEmpty &&
                    controller.withdrawType.value.isNotEmpty) {
                  controller.withdrawPoints();
                } else {
                  Get.snackbar("Error", "Please fill in all fields", snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Text('Withdraw Points'),
            ),
          ],
        ),
      ),
    );
  }
}
