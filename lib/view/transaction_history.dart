import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../controllers/history_controller.dart';
import '../utils/app_color.dart';

class TransactionHistoryPage extends StatelessWidget {
  final HistoryController controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Report"),
        backgroundColor: AppColors.main,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date pickers for 'From' and 'To' dates

            Obx(() => ListTile(
              title: Text("From: ${DateFormat('yyyy-MM-dd').format(controller.selectedFromDate.value)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => controller.pickFromDate(context),
            )),
            Obx(() => ListTile(
              title: Text("To: ${DateFormat('yyyy-MM-dd').format(controller.selectedToDate.value)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () => controller.pickToDate(context),
            )),

            SizedBox(height: 20),
            // Button to fetch history
            ElevatedButton(
              onPressed: controller.fetchHistory,
              child: Text('Download Report'),
            ),
            ElevatedButton(
              onPressed: controller.fetchHistory,
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            // Display history
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                if (controller.historyList.isEmpty) {
                  return Center(child: Text('No history available for this date range.'));
                }
                return ListView.builder(
                  itemCount: controller.historyList.length,
                  itemBuilder: (context, index) {
                    final historyItem = controller.historyList[index];
                    return ListTile(
                      title: Text('Yantra: ${historyItem['yantra_name']}'),
                      subtitle: Text('Points: ${historyItem['points']}'),
                      trailing: Text('Date: ${historyItem['date']}'),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
