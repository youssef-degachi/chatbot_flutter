// lib/services/gemini_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAPI {
  static const String _baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent";
  static const String _apiKey = "AIzaSyCHJ3Po2X3bfcZKfZpTM5GijCzCCKWDXAw"; // Replace with your actual API key

  static Future<String> sendMessage(Map<String, dynamic> messageData) async {
    final url = Uri.parse('$_baseURL?key=$_apiKey');

    try {
      // Check the structure of the messageData and adjust accordingly
      final body = jsonEncode({
        'input': messageData['input'],  // Use the correct field name based on API docs
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
        return data['text'];  // Update this based on the actual response structure
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to communicate with Gemini API: $e');
    }
  }
}
