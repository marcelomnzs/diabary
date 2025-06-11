import 'dart:convert';
// import 'package:diabary/features/chatbot/api.key.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<String> getOpenRouterResponse(String pergunta) async {
  var apiKey = dotenv.env['API_CHATBOT'] ?? '';
  const endpoint = 'https://api.groq.com/openai/v1/chat/completions';

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };
  final body = jsonEncode({
    'model': 'llama-3.3-70b-versatile',
    'messages': [
      {'role': 'user', 'content': pergunta},
    ],
    'temperature': 0.1,
  });

  final response = await http.post(
    Uri.parse(endpoint),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception(
      'Failed to load response: ${response.statusCode}\n${response.body}',
    );
  }
}
