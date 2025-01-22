import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_list.dart';

class GetPostService {
  static var client = http.Client();
  final storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> getPost({
    required String id,
  }) async {
    // Retrieve the token from secure storage
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    if (token == null) {
      log('Error: Token not found in secure storage');
      return {'status': false, 'message': 'Token not found'};
    }

    try {
      final url = Uri.parse("${ApiList.getPost!}?id=${id}");

      var response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );

      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Check if we got valid post data by checking essential fields
        if (responseBody.containsKey('id') && responseBody.containsKey('entity_type')) {
          return {
            'status': true,
            'data': responseBody,
            'entity_type': responseBody['entity_type'],
          };
        } else {
          return {
            'status': false,
            'message': 'Invalid post data received'
          };
        }
      } else {
        return {
          'status': false,
          'message': 'Failed to fetch post data'
        };
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return {
        'status': false,
        'message': 'Network connection error'
      };
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return {
        'status': false,
        'message': 'Failed to connect to server'
      };
    } catch (e) {
      log('Unexpected error: $e');
      return {
        'status': false,
        'message': 'An unexpected error occurred'
      };
    }
  }
}