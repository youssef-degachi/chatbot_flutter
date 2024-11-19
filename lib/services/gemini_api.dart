// lib/services/gemini_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAPI {
  static const String _baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent";
  static const String _apiKey = "AIzaSyCHJ3Po2X3bfcZKfZpTM5GijCzCCKWDXAw"; // Replace with your actual API key

  static Future<String> sendMessage(String message) async {
    final url = Uri.parse('$_baseURL?key=$_apiKey');

    try {
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': message}
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to communicate with Gemini API: $e');
    }
  }
}