// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// import '../api_list.dart';
//
// class ChangePassword {
//   static var client = http.Client();
//
//   static Future<bool?> changePassword({
//     required String? phoneNumber,
//     required String password,
//   }) async {
//     var body = jsonEncode({
//       "username": phoneNumber,
//       "password": password,
//     });
//
//     try {
//       var response = await client.post(
//         Uri.parse(ApiList.changePassword!),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//
//       log('Response status: ${response.statusCode}');
//       log('Response body: ${response.body}');
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseBody = json.decode(response.body);
//         bool status = responseBody['status'];
//         if (status) {
//           return true;
//         } else {
//           return false;
//         }
//       } else {
//         log('Failed to register: ${response.statusCode}');
//         return false;
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
// }



import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_list.dart';

class ChangePassword {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool?> changePassword({
    String? phoneNumber,
    required String password,
  }) async {
    try {
      // First try to get token from secure storage
      final token = await storage.read(key: 'token');

      // Create the request body based on available credentials
      Map<String, dynamic> requestBody = {
        "password": password,
      };

      // If token exists, use token-based authentication
      // Otherwise, fall back to phone number
      if (token != null && token.isNotEmpty) {
        requestBody["token"] = token;
      } else if (phoneNumber != null && phoneNumber.isNotEmpty) {
        requestBody["username"] = phoneNumber;
      } else {
        log('Error: Both token and phone number are missing');
        return false;
      }

      var response = await client.post(
        Uri.parse(ApiList.changePassword!),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'token': token,
        },
        body: jsonEncode(requestBody),
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        bool status = responseBody['status'];
        return status;
      } else {
        log('Failed to change password: ${response.statusCode}');
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