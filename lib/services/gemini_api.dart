// AIzaSyCHJ3Po2X3bfcZKfZpTM5GijCzCCKWDXAw
// lib/services/gemini_api.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class GeminiAPI {
  static const String _baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";
  static const String _imageURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent";
  static const String _apiKey = "AIzaSyBjIhjxalKViwt1nWQ_aUncCu_9SbPVfy8"; // Replace with your actual API key

  // Text-only message
  static Future<String> sendTextMessage(String message) async {
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
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response';
      } else {
        // throw Exception('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Error communicating with Gemini try simple and clear task');
      }
    } catch (e) {
      // return 'Error communicating with Gemini: $e';
      return 'Error communicating with Gemini try simple and clear task';
    }
  }

  // Image and text message
  static Future<String> sendImageMessage(File imageFile, String message) async {
    final url = Uri.parse('$_imageURL?key=$_apiKey');

    try {
      // Convert image to base64
      Uint8List imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': message},
              {
                'inlineData': {
                  'mimeType': 'image/jpeg', // or appropriate mime type
                  'data': base64Image
                }
              }
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response';
      } else {
        throw Exception('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // return 'Error processing image: $e';
      return 'the API is in free version try Gemini Pro';
    }
  }
}