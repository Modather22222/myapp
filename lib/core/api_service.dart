
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getAnswer(String question) async {
    // Read the API key inside the method, ensuring dotenv is loaded.
    final apiKey = dotenv.env['API_KEY'];

    // Add a robust check to ensure the key is not null or empty.
    if (apiKey == null || apiKey.isEmpty) {
      const errorMsg = 'API_KEY not found or is empty in .env file. Please ensure it is set correctly.';
      developer.log(errorMsg, name: 'ApiService.Error', level: 1200);
      throw Exception(errorMsg);
    }
    
    const String apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
    developer.log('Sending request to: $apiUrl');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          'HTTP-Referer': 'http://localhost', // Required by OpenRouter
          'X-Title': 'DeepSeek AI Flutter App', // Recommended by OpenRouter
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-chat-v3.1:free',
          'messages': [
            {'role': 'user', 'content': question},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['choices'] != null && data['choices'].isNotEmpty) {
          return data['choices'][0]['message']['content'].trim();
        } else {
          throw Exception('No valid response from API.');
        }
      } else {
        final errorMessage =
            'Error ${response.statusCode}: ${response.reasonPhrase} - ${response.body}';
        developer.log(errorMessage, name: 'api.error', level: 1000);
        throw Exception(errorMessage);
      }
    } catch (e, s) {
      developer.log('An error occurred while calling the API: $e', name: 'api.error', error: e, stackTrace: s);
      rethrow;
    }
  }
}
