  import 'dart:convert';
  import 'dart:developer';
  import 'dart:io';
  import 'package:http/http.dart' as http;
  import 'package:flutter_secure_storage/flutter_secure_storage.dart';
  import 'package:onesignal_flutter/onesignal_flutter.dart';
  import 'api_list.dart';

  class OnesignalService {
    static var client = http.Client();
    static final storage = FlutterSecureStorage();

    static Future<bool?> onesignalId() async {
      final oneSignalId = await initOneSignal();
      var body = jsonEncode({
        "onesignal_id": oneSignalId,
      });

      try {
        // Fetch the token from Flutter Secure Storage
        final token = await storage.read(key: 'token');
        if (token == null) {
          log('Error: Token not found in Flutter Secure Storage');
          return null;
        }

        var response = await client.post(
          Uri.parse(ApiList.onesignalId!),
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
          return status;
        } else {
          log('Failed to send onesignal id: ${response.statusCode}');
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
    }

  }
