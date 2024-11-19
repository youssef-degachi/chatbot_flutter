import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAPI {
  static const _apiKey = "AIzaSyCHJ3Po2X3bfcZKfZpTM5GijCzCCKWDXAw";

  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('https://geminai.api.example/sendMessage'); // Replace with the actual API URL

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $_apiKey'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response']; // Replace with actual response key
    } else {
      throw Exception('Failed to fetch response');
    }
  }
}
