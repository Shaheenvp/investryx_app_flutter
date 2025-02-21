import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import
import '../api_list.dart';

class TestimonialGet {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<Map<String, dynamic>?> fetchTestimonials({
    required String advisorId,
  }) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.testimonial!}?advisorId=$advisorId'),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Extract data and average rating
        double avgRating = 0.0;
        List<Map<String, dynamic>> testimonials = [];

        if (responseBody.containsKey('data') && responseBody['data'] is List) {
          testimonials = List<Map<String, dynamic>>.from(responseBody['data']);
        }

        if (responseBody.containsKey('avg_rating')) {
          // Handle different types of average rating value
          var ratingValue = responseBody['avg_rating'];
          if (ratingValue is int) {
            avgRating = ratingValue.toDouble();
          } else if (ratingValue is double) {
            avgRating = ratingValue;
          } else if (ratingValue is String) {
            avgRating = double.tryParse(ratingValue) ?? 0.0;
          }
        }

        return {
          'testimonials': testimonials,
          'avgRating': avgRating,
        };
      } else {
        log('Failed to fetch testimonials: ${response.statusCode}');
        return null;
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

  static Future<bool> deleteTestimonial(String testimonialId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return false;
      }

      var response = await client.delete(
        Uri.parse('${ApiList.testimonial!}$testimonialId'),
        headers: {
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        log('Testimonial deleted successfully');
        return true;
      } else {
        log('Failed to delete Testimonial: ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return false;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error: $e');
      return false;
    }
  }
}

