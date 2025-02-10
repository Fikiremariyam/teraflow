import 'dart:convert';
import 'package:flutter/services.dart';

class ResourceService {
  static Future<List<dynamic>> loadResources() async {
    final String response =
        await rootBundle.loadString('assets/resources.json');
    final data = jsonDecode(response);
    return data['resources'];
  }
}
