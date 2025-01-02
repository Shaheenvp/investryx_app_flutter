import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';

class AadhaarDetailsPostService {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<int?> aadhaarDetailsPost({
    required String firstName,
    required String dob,
    required String email,
    required String phone,
    required String gender,
    required String address,
    required String profileImage,
  }) async {
    var body = jsonEncode({
      "name": firstName,
      "dob": dob,
      "email": email,
      "number": phone,
      "gender": gender,
      "profile_image": profileImage,
      "address": address,
    });

    try {
      // Fetch the token from Flutter Secure Storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in Flutter Secure Storage');
        return null;
      }

      var response = await client.post(
        Uri.parse(ApiList.aadhaar!),
        headers: {
          'Content-Type': 'application/json',
          'token': token, // Pass the token in the header
        },
        body: body,
      );

      log('Response: ${response.statusCode} - ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];
      if(response.statusCode == 422) {
        return 422;
      }else if (response.statusCode == 201) {
          return 200;
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
