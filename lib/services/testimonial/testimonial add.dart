import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import

import '../api_list.dart';

class TestimonialAdd {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<bool?> testimonial({
    required String companyName,
    required String testimonial,
  }) async {
    try {
      // Retrieve token from secure storage
      final token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var body = jsonEncode({
        "company": companyName,
        "testimonial": testimonial,
      });

      var response = await client.post(
        Uri.parse(ApiList.testimonial!),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Add token to request headers
        },
        body: body,
      );

      print('Response: ${response.statusCode} - ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];
      if (status) {
        return status;
      } else {
        log('Failed to add testimonial: ${response.statusCode}');
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
