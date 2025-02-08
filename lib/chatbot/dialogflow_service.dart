import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';

class DialogFlowService {
  late AutoRefreshingAuthClient _client;
  static const String _dialogflowUrl =
      "https://dialogflow.googleapis.com/v2/projects/YOUR_PROJECT_ID/agent/sessions/YOUR_SESSION_ID:detectIntent";

  Future<void> _initializeAuth() async {
    final jsonString = await rootBundle.loadString('assets/service.json');
    final credentials =
        ServiceAccountCredentials.fromJson(json.decode(jsonString));
    final client = await clientViaServiceAccount(
        credentials, ['https://www.googleapis.com/auth/cloud-platform']);
    _client = client;
  }

  Future<String> sendMessage(String query) async {
    await _initializeAuth();

    final response = await _client.post(
      Uri.parse(_dialogflowUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "queryInput": {
          "text": {
            "text": query,
            "languageCode": "en",
          }
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['queryResult']['fulfillmentText'];
    } else {
      throw Exception("Failed to connect to Dialogflow: ${response.body}");
    }
  }
}
