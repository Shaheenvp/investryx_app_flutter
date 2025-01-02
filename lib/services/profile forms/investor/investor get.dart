import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';  // Import Flutter Secure Storage
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/all profile model.dart';
import '../../api_list.dart';

class InvestorFetchPage {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();  // Initialize Flutter Secure Storage

  static Future<List<BusinessInvestorExplr>?> fetchInvestorData() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      final response = await client.get(
        Uri.parse('${ApiList.investorAddPage!}1'),
        headers: {
          'token': token,  // Add token to request headers
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<BusinessInvestorExplr> investors = data.map((json) => BusinessInvestorExplr.fromJson(json)).toList();
        return investors;
      } else {
        log('Failed to fetch investor data: ${response.statusCode}');
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

  static Future<void> deleteInvestor(String investorId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        throw Exception('Token not found');
      }

      var response = await client.delete(
        Uri.parse('${ApiList.investorAddPage!}$investorId'),
        headers: {
          'token': token,  // Add token to request headers
        },
      );

      if (response.statusCode == 200) {
        log('Investor deleted successfully');
      } else {
        log('Failed to delete investor: ${response.statusCode}');
        throw Exception('Failed to delete investor');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw Exception('No Internet connection');
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception('Client error');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error');
    }
  }

  static Future<void> deleteInvestorProfile() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        throw Exception('Token not found');
      }

      var response = await client.delete(
        Uri.parse('${ApiList.investorAddPage!}${0}'),
        headers: {
          'token': token,  // Add token to request headers
        },
      );

      if (response.statusCode == 200) {
        log('Investor deleted successfully');
      } else {
        log('Failed to delete investor: ${response.statusCode}');
        throw Exception('Failed to delete investor');
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      throw Exception('No Internet connection');
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      throw Exception('Client error');
    } catch (e) {
      log('Unexpected error: $e');
      throw Exception('Unexpected error');
    }
    }
}
