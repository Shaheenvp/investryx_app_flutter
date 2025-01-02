// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import '../api_list.dart';
//
// class TestimonialGet {
//   static var client = http.Client();
//
//   static Future<List<Map<String, dynamic>>?> fetchTestimonials({
//     required String userId,
//   }) async {
//     try {
//       var response = await client.get(
//         Uri.parse('${ApiList.testimonial!}$userId'),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//       );
//       print('Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         List<dynamic> responseBody = json.decode(response.body);
//         List<Map<String, dynamic>> testimonials = responseBody.cast<Map<String, dynamic>>();
//         return testimonials;
//       } else {
//         log('Failed to fetch testimonials: ${response.statusCode}');
//         return null;
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       return null;
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       return null;
//     } catch (e) {
//       log('Unexpected error: $e');
//       return null;
//     }
//   }
//
//   static Future<void> deleteTestimonial(String testimonialId) async {
//     try {
//       var response = await client
//           .delete(Uri.parse('${ApiList.testimonial!}$testimonialId?'));
//
//       if (response.statusCode == 200) {
//         log('Testimonial deleted successfully');
//       } else {
//         log('Failed to delete Testimonial: ${response.statusCode}');
//         throw Exception('Failed to delete Business');
//       }
//     } on SocketException catch (e) {
//       log('SocketException: ${e.message}');
//       throw Exception('No Internet connection');
//     } on http.ClientException catch (e) {
//       log('ClientException: ${e.message}');
//       throw Exception('Client error');
//     } catch (e) {
//       log('Unexpected error: $e');
//       throw Exception('Unexpected error');
//     }
//   }
//
// }


import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Add this import
import '../api_list.dart';

class TestimonialGet {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<List<Map<String, dynamic>>?> fetchTestimonials({
     required String userId,
  }) async {
    try {
      // Retrieve token from secure storage
      final token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.testimonial!}?userId=${userId}'),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Add token to request headers
        },
      );
      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        List<Map<String, dynamic>> testimonials = responseBody.cast<Map<String, dynamic>>();
        return testimonials;
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
      // Retrieve token from secure storage
      final token = await storage.read(key: 'token');

      if (token == null) {
        log('Error: token not found in secure storage');
        return false; // Return false to indicate failure
      }

      var response = await client.delete(
        Uri.parse('${ApiList.testimonial!}$testimonialId'),
        headers: {
          'token': token, // Add token to request headers
        },
      );

      if (response.statusCode == 200) {
        log('Testimonial deleted successfully');
        return true; // Return true to indicate success
      } else {
        log('Failed to delete Testimonial: ${response.statusCode}');
        return false; // Return false to indicate failure
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return false; // Return false to indicate failure
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return false; // Return false to indicate failure
    } catch (e) {
      log('Unexpected error: $e');
      return false; // Return false to indicate failure
    }
  }
}
