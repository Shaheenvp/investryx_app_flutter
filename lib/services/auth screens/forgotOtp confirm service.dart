import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api_list.dart';

class ForgotOtpConfirm {
  static var client = http.Client();

  static Future<Object?> forgotOtp({
    required String phone,
    required String otp,
  }) async {
    var body = jsonEncode({
      "phone": phone,
      "otp" :otp
    });

    try {
      var response = await client.post(
        Uri.parse(ApiList.forgotOtpConform!),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
      Map<String, dynamic> responseBody = json.decode(response.body);
      bool status = responseBody['status'];
      if (status) {
        // await saveOtpToPreferences(otp);
        return status;
      } else {
        log('Failed to send otp: ${response.statusCode}');
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