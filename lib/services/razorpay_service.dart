import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'api_list.dart';

class RazorpayService {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<List<Map<String, dynamic>>?> fetchOrderId(String id) async {
    try {
      String? token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.razorpay!}?id=$id'),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
      );

      print('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> responseBody = json.decode(response.body);
        List<Map<String, dynamic>> banners = responseBody.cast<Map<String, dynamic>>();
        return banners;
      } else {
        log('Failed to fetch Order Id: ${response.statusCode}');
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
}