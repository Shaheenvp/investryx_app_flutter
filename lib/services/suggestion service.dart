import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_list.dart';

class Suggestion {
  static var client = http.Client();
  final storage = FlutterSecureStorage();

  static Future<bool?> suggestion({
    required String message,
  }) async {
    // Retrieve the token from secure storage
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      log('Error: Token not found in secure storage');
      return null;
    }

    var body = jsonEncode({
      "suggestions": message,
    });

    try {
      var response = await client.post(
        Uri.parse(ApiList.suggestion!),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Pass the token in the header
        },
        body: body,
      );

      log('Response: ${response.statusCode} - ${response.body}');

      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];

      if (status) {
        return status;
      } else {
        log('Failed to send suggestion: ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}
