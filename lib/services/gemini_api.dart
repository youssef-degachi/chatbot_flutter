// services/gemini_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAPI {
  static const String _baseURL = "https://ai.google.dev/gemini-api";
  static const String _apiKey = "AIzaSyCHJ3Po2X3bfcZKfZpTM5GijCzCCKWDXAw";

  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('$_baseURL/generateContent');

    final requestPayload = {
      "model": "gemini-1.5-flash",
      "prompt": message,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text']; // Update if your API response format differs
      } else {
        throw Exception('API Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to communicate with Gemini API: $e');
    }
  }
}