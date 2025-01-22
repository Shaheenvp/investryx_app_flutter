import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';

class NotificationService {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  // Method for fetching Notifications
  static Future<List<ProductDetails>?> fetchNotification() async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      final response = await client.get(
        Uri.parse(ApiList.notification!),
        headers: {
          'token': token, // Include token in headers
        },
      );
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List;
        List<ProductDetails> recommendedItems =
        data.map((json) => ProductDetails.fromJson(json)).toList();
        return recommendedItems;
      } else {
        log('Failed to fetch notification data: ${response.statusCode}');
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

  // Method for deleting a Notification
  static Future<bool> deleteNotification(int notificationId) async {
    try {
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return false;
      }

      final deleteUrl = Uri.parse('${ApiList.notification}$notificationId');

      final response = await client.delete(
        deleteUrl,
        headers: {
          'token': token, // Include token in headers
          'Content-Type': 'application/json',
        },
      );

      log('Delete Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        log('Failed to delete notification: ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      log('SocketException: ${e.message}');
      return false;
    } on http.ClientException catch (e) {
      log('ClientException: ${e.message}');
      return false;
    } catch (e) {
      log('Unexpected error: $e');
      return false;
    }
  }
}

class ProductDetails {
  final int id;
  final String imageUrl;
  final String title;
  final String description;
  final String date;
  final String url;

  ProductDetails({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.url,
    required this.description,
    required this.date,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      id: json['id'],
      url: json['url'].toString(),
      imageUrl: validateUrl(json['image']) ?? 'https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=',
      title: json['title'] ?? 'N/A',
      description: json['description'] ?? 'N/A',
      date: json['created_on'] ?? 'N/A',
    );
  }

  static String? validateUrl(String? url) {
    const String baseUrl = ApiList.imageBaseUrl;

    if (url == null || url.isEmpty) {
      return null;
    }

    try {
      var uri = Uri.parse(url);
      if (!uri.hasScheme) {
        url = baseUrl + (url.startsWith('/') ? url.substring(1) : url);
        uri = Uri.parse(url);
      }
      if (uri.hasScheme && (uri.hasAuthority || uri.host.isNotEmpty)) {
        return url;
      }
    } catch (e) {
      return null;
    }
    return null;
    }
}
