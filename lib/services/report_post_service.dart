import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';

class ReportPost {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool?> reportPost({
    required String reason,
    required String reasonType,
    required String postId,
  }) async {

    var body = jsonEncode({
      "reason": reason,
      "reason_type": reasonType,
      "id": postId,
    });

    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in Flutter Secure Storage');
        return null;
      }

      var response = await client.post(
        Uri.parse(ApiList.report),
        headers: {
          'Content-Type': 'application/json',
          'token': token,
        },
        body: body,
      );

      log('Response: ${response.statusCode} - ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);

      bool status = responseBody['status'];
      if (status) {
        return true; // Post reported successfully
      } else {
        log('Failed to report post: ${responseBody['message']}');
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
