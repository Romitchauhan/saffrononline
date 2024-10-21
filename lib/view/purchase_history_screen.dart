import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/purchase_history_controller.dart';
import '../utils/app_color.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  final PurchaseHistoryController controller = Get.put(PurchaseHistoryController());
  final TextEditingController userIdController = TextEditingController();

  void _fetchPurchaseHistory() {
    final userId = userIdController.text;
    if (userId.isNotEmpty) {
      controller.resetState();
      controller.fetchPurchaseHistory(userId);
    } else {
      Get.snackbar('Error', 'User ID is required');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Purchase History',style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.main,
        iconTheme: IconThemeData(color: Colors.white),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input field for user ID
            TextField(
              controller: userIdController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter User ID',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _fetchPurchaseHistory(), // Trigger fetch on submit
            ),
            SizedBox(height: 10),
            // Fetch button
            ElevatedButton(
              onPressed: _fetchPurchaseHistory,
              child: Text('Fetch History'),
            ),
            SizedBox(height: 20),
            // Loading and error handling
            Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator()); // Show loading indicator
              } else if (controller.error.value.isNotEmpty) {
                return Center(
                  child: Text(controller.error.value, style: TextStyle(color: Colors.red)),
                ); // Show one error message
              } else if (controller.purchaseHistory.isEmpty) {
                return Center(
                  child: Text('No purchase history available.', style: TextStyle(color: Colors.grey)),
                ); // No data case
              } else {
                // Display purchase history when data is available
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.purchaseHistory.length,
                    itemBuilder: (context, index) {
                      var history = controller.purchaseHistory[index];
                      var pointData = history['point_data'] ?? [];
                      if (pointData.isEmpty) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text('No point data available for this entry.'),
                          ),
                        );
                      }

                      // Ensure pointData has at least one entry before accessing it
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Yantra: ${pointData[0]['yantra_name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('Count: ${pointData[0]['yantra_count']}'),
                              Text('Price: ${pointData[0]['yantra_price']}'),
                              Text('Points: ${pointData[0]['yantra_point']}'),
                              SizedBox(height: 10),
                              Text('Generated Time: ${history['time_generated']}'),
                              Text('Created At: ${history['created_at']}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
