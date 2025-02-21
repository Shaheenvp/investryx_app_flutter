import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import

import '../api_list.dart';

class TestimonialAdd {
  static final client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool?> testimonial({
    required int rating,
    required String testimonial,
    required String advisorId,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      final response = await client.post(
        Uri.parse(ApiList.testimonial!),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: jsonEncode({
          "rate": rating,
          "testimonial": testimonial,
          "advisorId": advisorId,
        }),
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode != 200) {
        log('Server error: ${response.statusCode}');
        return false;
      }

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      return responseBody['status'] as bool? ?? false;

    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return null;
    } on FormatException catch (e) {
      log('FormatException (Invalid JSON): ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}