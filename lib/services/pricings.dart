// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
//
// import 'api_list.dart';
//
//
//
// class PlansGet {
//   static var client = http.Client();
//   static final storage = FlutterSecureStorage(); // Create a secure storage instance
//
//
//   static Future<List<Map<String, dynamic>>?> fetchPlans(String type) async {
//     try {
//       final token = await storage.read(key: 'token');
//       if (token == null) {
//         log('Error: Token not found in secure storage');
//         return null;
//       }
//
//       var response = await client.get(
//         Uri.parse('${ApiList.pricing}?type=$type'),
//         headers: {
//           'Content-Type': 'application/json',
//           'token': token,
//         },
//       );
//
//       print('Response: ${response.statusCode} - ${response.body}');
//
//       if (response.statusCode == 200) {
//         List responseBody = json.decode(response.body);
//         return responseBody.cast<Map<String, dynamic>>();
//       } else {
//         debugPrint('Failed to fetch plans: ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching plans: $e');
//       return null;
//     }
//   }
//
// }



import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'api_list.dart';

class PlansGet {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<List<Map<String, dynamic>>?> fetchPlans(String type) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.pricing}?type=$type'),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        List responseBody = json.decode(response.body);

        // Map the response to ensure all required keys are present
        List<Map<String, dynamic>> plans = responseBody.map<Map<String, dynamic>>((plan) {
          return {
            'id': plan['id']?.toString(),
            'name': plan['name']?.toString() ?? 'Unknown Plan',
            'rate': plan['rate']?.toString() ?? '0',
            'description': plan['description'] ?? {},
            'type': plan['type']?.toString(),
            'key': plan['key']?.toString() ?? '', // Ensure key is fetched
            'recommend': plan['recommend'] ?? false,
            'time_period': plan['time_period'],
            'post_number': plan['post_number'],
            'feature': plan['feature'] ?? false,
          };
        }).toList();

        return plans;
      } else {
        debugPrint('Failed to fetch plans: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching plans: $e');
      return null;
    }
  }
}