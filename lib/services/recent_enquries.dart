import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_emergio/services/api_list.dart'; // Add this import

class RecentEnquiries {
  static var client = http.Client();
  static final storage = FlutterSecureStorage(); // Initialize secure storage

  static Future<List<enquiry>?> fetchEnquiries({required String? id}) async {
    try {
      // Retrieve token from secure storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.recentEnquiries}?id=$id'),
        headers: {
          'token': token,
          'Content-Type': 'application/json',
        },
      );

      print('Response of recent enquiries: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonData = jsonDecode(response.body);

        // Handle response when it's a List
        if (jsonData is List) {
          return jsonData.map<enquiry>((item) => enquiry.fromJson(item)).toList();
        }

        // Handle response when it's a Map with status and recent_enquiries
        else if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey("status") &&
            jsonData["status"] == true &&
            jsonData.containsKey("recent_enquiries")) {
          return (jsonData["recent_enquiries"] as List)
              .map((item) => enquiry.fromJson(item))
              .toList();
        }

        // If no valid data format is found, return empty list
        return [];
      } else if(response.statusCode == 405) {
        return [];
      } else {
        log('Failed to fetch enquiries: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      log('Network error: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('HTTP client error: ${e.message}');
      return null;
    } on FormatException catch (e) {
      log('JSON parsing error: ${e.message}');
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }

  static Future<EnquiryCounts?> fetchEnquiriesCounts(
      {required String? id}) async {
    try {
      // Retrieve token from secure storage
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in secure storage');
        return null;
      }

      var response = await client.get(
        Uri.parse('${ApiList.countEnquiries}?id=$id'),
        headers: {
          'token': token,
          'Content-Type': 'application/json',
        },
      );

      print('Response fetch counts: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var jsonData = jsonDecode(response.body);

          if (jsonData is Map<String, dynamic>) {
            return EnquiryCounts.fromJson(jsonData);
          } else {
            log('Error: Unexpected response data format');
            return null;
          }
        } else {
          log('Error: Response body is empty');
          return null;
        }
      } else if(response.statusCode == 405){
        return EnquiryCounts(todayCount: 0, yesterdayCount: 0, totalCount: 0, impressions: 0);
      }
      else {
        log('Failed to fetch enquiry counts: ${response.statusCode}');
        return null;
      }
    } on SocketException catch (e) {
      log('Network error: ${e.message}');
      return null;
    } on http.ClientException catch (e) {
      log('HTTP client error: ${e.message}');
      return null;
    } on FormatException catch (e) {
      log('JSON parsing error: ${e.message}');
      return null;
    } catch (e) {
      log('Unexpected error: $e');
      return null;
    }
  }
}

class enquiry {
  final int id;
  final UserDetails user;
  final String created;
  final int post;
  final int roomId;

  enquiry({
    required this.id,
    required this.user,
    required this.created,
    required this.post,
    required this.roomId,
  });

  factory enquiry.fromJson(Map<String, dynamic> json) {
    return enquiry(
      id: json['id'],
      user: UserDetails.fromJson(json['user']),
      created: json['created'],
      post: json['post'],
      roomId: json['room_id'],
    );
  }
}

class UserDetails {
  final int id;
  final String firstName;
  final String? image;
  final String username;

  UserDetails({
    required this.id,
    required this.firstName,
    this.image,
    required this.username,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['first_name'],
      image: json['image'],
      username: json['username'],
    );
  }
}


class EnquiryCounts {
  final int todayCount;
  final int yesterdayCount;
  final int totalCount;
  final int impressions;

  EnquiryCounts( {
    required this.todayCount,
    required this.yesterdayCount,
    required this.totalCount,
    required this.impressions,
  });

  factory EnquiryCounts.fromJson(Map<String, dynamic> json) {
    return EnquiryCounts(
      todayCount: json['today_count'] ?? 0,
        yesterdayCount: json['yesterday_count'] ?? 0,
        totalCount: json['total_count'] ?? 0,
      impressions: json['impressions']
        );
    }
}
