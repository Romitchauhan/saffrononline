import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgentController extends GetxController {
  var agentsList = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllAgents();
  }

  Future<void> fetchAllAgents() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('https://saffrononline.bhavenaayurveda.com/api/admin/agent-all.php'));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 1) {
          agentsList.value = data['data'];
        } else {
          Get.snackbar('Error', 'Failed to fetch agents');
        }
      } else {
        Get.snackbar('Error', 'Server Error');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
