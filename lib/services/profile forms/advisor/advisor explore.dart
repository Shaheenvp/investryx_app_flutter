import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Flutter Secure Storage
import '../../../models/all profile model.dart';
import '../../api_list.dart';

class AdvisorExplorePage {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize Flutter Secure Storage

  static Future<List<AdvisorExplr>?> fetchAdvisorExplore() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.advisorAddPage!}${0}'),
        headers: {'token': token}, // Add token to request headers
      );
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<AdvisorExplr> advisors =
        data.map((json) => AdvisorExplr.fromJson(json)).toList();
        return advisors;
      } else {
        log('Failed to fetch advisor data: ${response.statusCode}');
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

