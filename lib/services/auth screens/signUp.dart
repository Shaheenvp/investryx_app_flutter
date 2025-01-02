// // import 'dart:convert';
// // import 'dart:developer';
// // import 'dart:io';
// // import 'package:http/http.dart' as http;
// //
// // import '../api_list.dart';
// //
// // class SignUp {
// //   static var client = http.Client();
// //   static Future<bool?> signUp({
// //     required String name,
// //     required String email,
// //     required String phone,
// //     required String password,
// //   }) async {
// //     var body = jsonEncode({
// //       "name": name,
// //       "email": email,
// //       "phone": phone,
// //       "password": password,
// //     });
// //
// //     try {
// //       var response = await client.post(
// //         Uri.parse(ApiList.register!),
// //         headers: {
// //           'Content-Type': 'application/json',
// //         },
// //         body: body,
// //       );
// //       Map<String, dynamic> responseBody = json.decode(response.body);
// //       print('Error: ${response.statusCode} - ${response.body}');
// //       bool status = responseBody['status'];
// //       // int otp = responseBody['otp'];
// //       if (status) {
// //         return status;
// //       } else {
// //         log('Failed to register: ${response.statusCode}');
// //         return false;
// //       }
// //     } on SocketException catch (e) {
// //       log('SocketException: ${e.message}');
// //       return null;
// //     } on http.ClientException catch (e) {
// //       log('ClientException: ${e.message}');
// //       return null;
// //     } catch (e) {
// //       log('Unexpected error: $e');
// //       return null;
// //     }
// //   }
// // }
//
//
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
//
// import '../api_list.dart';
//
// class SignUp {
//   static var client = http.Client();
//   static final storage = FlutterSecureStorage();
//
//   static Future<bool?> signUp({
//     required String name,
//     required String email,
//     String? image,
//     required String phone,
//     required String password,
//     required int otp,
//   }) async {
//     var body = jsonEncode({
//       "name": name,
//       "images": image,
//       "email": email,
//       "phone": phone,
//       "password": password,
//       "otp": otp
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
//
//       if (status) {
//         // Check if token is present and not null
//         if (responseBody.containsKey('token') && responseBody['token'] != null) {
//           String token = responseBody['token'];
//
//           // Save token to Flutter secure storage
//           await storage.write(key: 'token', value: token);
//
//           // Retrieve and print the saved token
//           String? savedToken = await storage.read(key: 'token');
//           log('Saved token: $savedToken'); // Print the saved token
//         } else {
//           log('Token is missing or null in the response');
//         }
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
//

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
import 'package:onesignal_flutter/onesignal_flutter.dart'; // Import OneSignal
import '../api_list.dart';

class SignUp {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<bool?> signUp({
    required String name,
    required String email,
    String? image,
    required String phone,
    required String password,
    required int otp,
  }) async {
    final oneSignalId = await initOneSignal();
    print("passed onesignal id is ${oneSignalId}");
    var body = jsonEncode({
      "name": name,
      "images": image,
      "email": email,
      "phone": phone,
      "password": password,
      "otp": otp,
      "onesignal_id" : oneSignalId
    });

    try {

      var response = await client.post(
        Uri.parse(ApiList.register!),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      Map<String, dynamic> responseBody = json.decode(response.body);
      print('Error: ${response.statusCode} - ${response.body}');
      bool status = responseBody['status'];

      if (status) {
        // Check if token is present and not null
        if (responseBody.containsKey('token') && responseBody['token'] != null) {
          String token = responseBody['token'];

          // Save token to Flutter secure storage
          await storage.write(key: 'token', value: token);

          // Retrieve and print the saved token
          String? savedToken = await storage.read(key: 'token');
          log('Saved token: $savedToken'); // Print the saved token

          // Initialize OneSignal and pass the ID to the backend
        } else {
          log('Token is missing or null in the response');
        }
        return status;
      } else {
        log('Failed to register: ${response.statusCode}');
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

  static Future<String?> initOneSignal() async {
    // Set log level for debugging purposes
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Initialize OneSignal with your app ID
    OneSignal.initialize("697da393-f253-47db-b4fd-c6ca19cbd132");

    // Request push notification permissions
    await OneSignal.Notifications.requestPermission(true);

    // Add tags to segment users (optional)
    OneSignal.User.addTags({"segment": "Notifications"});

    String? oneSignalId;

    // Get push subscription ID after initialization
    Future<String?> getOneSignalIdWithDelay() async {
      // Delays the execution by 10 seconds
      await Future.delayed(Duration(seconds: 2));

      String? oneSignalId = await OneSignal.User.pushSubscription.id;
      log("OneSignal Push Subscription ID: $oneSignalId");
      return oneSignalId;
    }

    return await getOneSignalIdWithDelay();
    // Pass the OneSignal ID to your backend
    // await sendOneSignalIdToBackend(oneSignalId);
    //
    // // Handle notification clicks
    // OneSignal.Notifications.addClickListener((event) {
    //   final data = event.notification.additionalData;
    //   int? leadId = data?['lead_id'];
    //
    //   log("Notification data: $data");
    //
    //   // Handle lead navigation (optional)
    //   // if (leadId != null) {
    //   //   navigatorKey.currentState?.push(
    //   //     MaterialPageRoute(
    //   //       builder: (context) => LeadDetailScreen(leadId: leadId),
    //   //     ),
    //   //   );
    //   // }
    // });
  }

}
