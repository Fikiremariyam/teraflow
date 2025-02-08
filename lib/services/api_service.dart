import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Hardcoded Chapa API key
  static final String chapaSecretKey =
      'CHASECK_TEST-0XtVynStl5jc6LGHUSBTzNWSZALWZ4KD';

  static const String chapaBaseUrl =
      "https://api.chapa.co/v1/transaction/initialize";

  // Function to initiate a payment
  static Future<String?> initiatePayment({
    required String customerEmail,
    required String amount,
    required String reason,
    required String txRef,
  }) async {
    print(" Starting Payment Initialization...");

    // ✅ Check if API key is available
    if (chapaSecretKey.isEmpty) {
      print(" ERROR: Chapa API Key is missing. Check your .env file!");
      return null;
    } else {
      print("Chapa API Key Loaded Successfully!");
    }

    final url = Uri.parse(chapaBaseUrl);
    final headers = {
      "Authorization": "Bearer $chapaSecretKey",
      "Content-Type": "application/json",
    };

    final body = jsonEncode({
      "amount": amount,
      "currency": "ETB",
      "email": customerEmail,
      "tx_ref": txRef,
      //"callback_url":"yourapp://payment_callback", // Updated deep link for callback
      // "return_url": "yourapp://payment_success", // Updated deep link for return
      "customization": {
        "title": "Therapist", // Shortened title to meet the 16 characters limit
        "description": reason
      }
    });

    print("Sending HTTP POST Request to Chapa...");
    print(" Request URL: $url");
    print("Headers: $headers");
    print(" Body: $body");

    try {
      final response = await http.post(url, headers: headers, body: body);
      print(" Response Received!");
      print(" HTTP Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success" && data["data"] != null) {
          print("Payment Link Generated: ${data["data"]["checkout_url"]}");
          return data["data"]["checkout_url"];
        } else {
          print(" ERROR: Unexpected API response format.");
          print(" Full Response: $data");
          return null;
        }
      } else {
        print(" API ERROR: ${response.statusCode}");
        print(" Response Body: ${response.body}");
        return null;
      }
    } catch (e, stacktrace) {
      print(" EXCEPTION: $e");
      print(" Stacktrace: $stacktrace");
      return null;
    }
  }
}
