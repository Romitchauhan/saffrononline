import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Define the rechargeClient method
  static Future<Map<String, dynamic>> rechargeClient({
    required int custId,
    required String mobileNo,
    required String rechargeAmount,
    required String rechargeDate,
    required String rechargeType,
    required String rechargeId,
  }) async {
    final url = 'https://saffrononline.bhavenaayurveda.com/api/admin/client-recharge.php';

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "cust_id": custId,
        "mobileno": mobileNo,
        "recharge_amount": rechargeAmount,
        "recharge_date": rechargeDate,
        "recharge_type": rechargeType,
        "recharge_id": rechargeId
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to recharge client');
    }
  }
}
