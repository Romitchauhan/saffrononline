import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/game_controller.dart';

class ApiService1 {
  static const String fetchAllYantrasUrl = 'https://saffrononline.bhavenaayurveda.com/api/fetch-all-yantra.php';
  static const String fetchWinnerYantraUrl = 'https://saffrononline.bhavenaayurveda.com/api/fetch-winner-yantra.php';

  Future<List<Yantra>> fetchAllYantras() async {
    final response = await http.get(Uri.parse(fetchAllYantrasUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 1) {
        List<Yantra> yantras = (jsonData['data'] as List)
            .map((data) => Yantra.fromJson(data))
            .toList();
        return yantras;
      } else {
        throw Exception('Failed to load yantras');
      }
    } else {
      throw Exception('Failed to load yantras');
    }
  }

  Future<Yantra> fetchWinnerYantra() async {
    final response = await http.get(Uri.parse(fetchWinnerYantraUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['status'] == 1) {
        return Yantra.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load winner yantra');
      }
    } else {
      throw Exception('Failed to load winner yantra');
    }
  }

}
class GameService {
  Future<void> submitYantraSelection(List<int> yantraPoints) async {
    // Replace with your API endpoint or database saving logic
    final response = await http.post(
      Uri.parse(''),
      body: jsonEncode({'points': yantraPoints}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to submit selection');
    }
  }
}
