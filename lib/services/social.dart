// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// import '../api_list.dart';
//
// class SignUp {
//   static var client = http.Client();
//   static Future<bool?> signUp({
//     required String name,
//     required String email,
//     required String phone,
//     required String password,
//   }) async {
//     var body = jsonEncode({
//       "name": name,
//       "email": email,
//       "phone": phone,
//       "password": password,
//     });
//
//     try {
//       var response = await client.post(
//         Uri.parse(ApiList.register!),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: body,
//       );
//       Map<String, dynamic> responseBody = json.decode(response.body);
//       print('Error: ${response.statusCode} - ${response.body}');
//       bool status = responseBody['status'];
//       // int otp = responseBody['otp'];
//       if (status) {
//         return status;
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
import 'package:http/http.dart' as http;
import 'api_list.dart';

class Social {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Create a FlutterSecureStorage instance

  static Future<bool?> google({
    required String email,
  }) async {
    var body = jsonEncode({
      "username": email,
    });

    try {
      var response = await client.post(
        Uri.parse(ApiList.social!),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      print('Response: ${response.statusCode} - ${response.body}');
      bool status = responseBody['status'];

      if (status) {
        // Check if token is present and not null
        if (responseBody.containsKey('token') && responseBody['token'] != null) {
          String token = responseBody['token'];

          // Save the token to Flutter Secure Storage
          await storage.write(key: 'token', value: token);

          // Retrieve and log the saved token
          String? savedToken = await storage.read(key: 'token');
          log('Saved token: $savedToken'); // Print the saved token
        } else {
          log('Token is missing or null in the response');
        }
        return status;
      } else {
        log('Failed to login: ${response.statusCode}');
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
