import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class DialogflowService {
  static const String _projectId = 'tera-flow';
  late http.Client _client;
  String? _sessionId;

  Future<void> initialize() async {
    try {
      final jsonString =
          await rootBundle.loadString('assets/tera-flow-cb.json');
      final credentials =
          ServiceAccountCredentials.fromJson(json.decode(jsonString));

      final client = await clientViaServiceAccount(
        credentials,
        ['https://www.googleapis.com/auth/dialogflow'],
      );

      _client = client;
      _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

      print('Dialogflow initialized successfully');
    } catch (e) {
      print('Error initializing Dialogflow: $e');
      rethrow;
    }
  }

  Future<String> sendMessage(String message) async {
    if (_sessionId == null) {
      await initialize();
    }

    try {
      final response = await _client.post(
        Uri.parse(
            'https://dialogflow.googleapis.com/v2/projects/$_projectId/agent/sessions/$_sessionId:detectIntent'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'queryInput': {
            'text': {
              'text': message,
              'languageCode': 'en-US',
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['queryResult']['fulfillmentText'] ?? 'No response';
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}
