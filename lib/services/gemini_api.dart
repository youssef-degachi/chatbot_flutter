// services/gemini_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAPI {
  static const String _baseURL = "https://ai.google.dev/gemini-api";
  static const String _apiKey = "AIzaSyCHJ3Po2X3bfcZKfZpTM5GijCzCCKWDXAw"; // Replace with your actual API key

  /// Sends a message to the Gemini API and returns the response.
  static Future<String> sendMessage(String message) async {
    // Construct the full API URL
    final url = Uri.parse('$_baseURL/generateContent');

    // Prepare the request payload
    final requestPayload = {
      "model": "gemini-1.5-flash", // Specify the model as shown in the documentation
      "prompt": message,
    };

    try {
      // Make the HTTP POST request
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestPayload),
      );

      // Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['text']; // Replace 'text' with the actual key in the response
      } else {
        throw Exception('API Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to communicate with Gemini API: $e');
    }
  }
}
