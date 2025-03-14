import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_list.dart';

class TestimonialAdd {
  static final client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> testimonial({
    required int rating,
    required String testimonial,
    required String advisorId,
    BuildContext? context,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return {
          'success': false,
          'message': 'Authentication error',
        };
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

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': responseBody['status'] as bool? ?? false,
          'message': 'Review submitted successfully',
        };
      } else if (response.statusCode == 405) {
        return {
          'success': false,
          'message': "You can't rate your own profile",
        };
      } else if (response.statusCode == 406) {
        return {
          'success': false,
          'message': 'Your chat is too short to rate this profile',
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to submit review. Please try again later.',
        };
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return {
        'success': false,
        'message': 'Connection error. Please check your internet connection.',
      };
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return {
        'success': false,
        'message': 'Network error. Please try again later.',
      };
    } on FormatException catch (e) {
      log('FormatException (Invalid JSON): ${e.message}');
      return {
        'success': false,
        'message': 'Server returned invalid data. Please try again later.',
      };
    } catch (e) {
      log('Unexpected error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred. Please try again later.',
      };
    }
  }
}