import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_list.dart';

class CheckSubscription {
  static var client = http.Client();

  static Future<Map<String, dynamic>> fetchSubscription() async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      log('Error: Token not found in secure storage');
      return {'status': false};
    }

    try {
      var response = await client.get(
        Uri.parse('${ApiList.checkSubscribed!}'),
        headers: {
          'Content-Type': 'application/json',
          'token':token
        },
      );
      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = json.decode(response.body);
        if(responseBody['status']){
          return {'status': true, 'id': responseBody['id']};
        } else{
          return {'status': false};
        }

      } else {
        debugPrint('Failed to fetch subscription data: ${response.statusCode}');
        return {'status': false};
      }
    } on SocketException catch (e) {
      debugPrint('SocketException: ${e.message}');
      return {'status': false};
    } on http.ClientException catch (e) {
      debugPrint('ClientException: ${e.message}');
      return {'status': false};
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return {'status': false};
    }
  }

  // Post the transaction details after payment
  static Future<bool> postTransactionDetails({
    required String transactionId,
    required String id,
  }) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      log('Error: Token not found in secure storage');
      return false;
    }
    try {
      var response = await client.post(
        Uri.parse(ApiList.checkSubscribed!),
        headers: {
          'Content-Type': 'application/json',
          'token': token
        },
        body: json.encode({
          'id': id,
          'transaction_id': transactionId,
        }),
      );
      print('Post Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        // Check for 'status' instead of 'success'
        return responseBody['status'] ?? false;
      } else {
        debugPrint('Failed to post transaction details: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return false;
    }
  }



  static Future<Map<String, dynamic>> checkfetchSubscription(String type) async {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');

    if (token == null) {
      log('Error: Token not found in secure storage');
      return {'status': false};
    }

    try {
      var response = await client.get(
        Uri.parse('${ApiList.checkSubscribed!}?type=$type'),
        headers: {
          'Content-Type': 'application/json',
          'token':token
        },
      );
      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        var responseBody = json.decode(response.body);
        if(responseBody['status']){
          return {'status': true, 'id': responseBody['id']};
        } else{
          return {'status': false};
        }

      } else {
        debugPrint('Failed to fetch subscription data: ${response.statusCode}');
        return {'status': false};
      }
    } on SocketException catch (e) {
      debugPrint('SocketException: ${e.message}');
      return {'status': false};
    } on http.ClientException catch (e) {
      debugPrint('ClientException: ${e.message}');
      return {'status': false};
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return {'status': false};
    }
    }
}
