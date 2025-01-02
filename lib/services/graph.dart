import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'api_list.dart';

class GraphService {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  // Method for fetching graph data
  static Future<GraphData?> fetchGraph() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      final response = await client.get(
        Uri.parse(ApiList.graph!),
        headers: {
          'token': token,
        },
      );
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return GraphData.fromJson(data);
      } else {
        log('Failed to fetch graph data: ${response.statusCode}');
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

class GraphData {
  final List<GraphDetails> business;
  final List<GraphDetails> investor;
  final List<GraphDetails> franchise;
  final int total;
  final int invest;

  GraphData({
    required this.business,
    required this.investor,
    required this.franchise,
    required this.total,
    required this.invest,
  });

  int get totalValue => total;
  int get investValue => invest;

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(

      business: (json['business'] as List)
          .map((item) => GraphDetails.fromJson(item))
          .toList(),
      investor: (json['investor'] as List)
          .map((item) => GraphDetails.fromJson(item))
          .toList(),
      franchise: (json['franchise'] as List)
          .map((item) => GraphDetails.fromJson(item))
          .toList(),
      total: json['total'],
      invest: json['invest'],
    );

  }
}

class GraphDetails {
  final int month;
  final int? totalRate;

  GraphDetails({
    required this.month,
    required this.totalRate,
  });

  factory GraphDetails.fromJson(Map<String, dynamic> json) {
    return GraphDetails(
      month: json['month'],
      totalRate: json['total_rate'],
    );
  }
}

