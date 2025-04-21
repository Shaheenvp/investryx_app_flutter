import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';

class ContactUs {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool?> contactUs({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String message,
  }) async {
    var body = jsonEncode({
      "firstname": firstName,
      "lastname": lastName,
      "email": email,
      "number": phone,
      "message": message,
    });

    try {
      // Fetch the token from Flutter Secure Storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in Flutter Secure Storage');
        return null;
      }

      var response = await client.post(
        Uri.parse(ApiList.contactUs!),
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
        log('Failed to send: ${response.statusCode}');
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
