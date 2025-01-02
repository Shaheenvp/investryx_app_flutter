import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_list.dart';


class ChatUserCheck {
  static var client = http.Client();
  static final storage = FlutterSecureStorage();

  static Future<int?> fetchChatUserData() async {
    try {
      print("working");
      final token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: token not found in Flutter Secure Storage');
        return null;
      }

      final response = await client.get(
        Uri.parse('${ApiList.chatUserCheck!}'),
        headers: {
          'token': token,  // Add token to request headers
        },
      );

      log('Response body: ${response.body}'); // Log the raw response

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        print(userData); // For debugging
        final user = checkUser.fromJson(userData);
        print('Name: ${user.id}');
        return user.id;
        // var data = jsonDecode(response.body);

        // Check if the data is a List
        // if (data is List) {
        //   List<checkUser> inboxItems = data.map((json) => checkUser.fromJson(json)).toList();
        //   print("hy7gyy${inboxItems}");
        //
        //   return inboxItems;
        // } else if (data is Map) {
        //   // Handle the case where the response is a Map
        //   // Example: Map might have a key like 'items' which contains the list
        //   var items = data['items'] as List?;
        //   if (items != null) {
        //     List<checkUser> userItems = items.map((json) => checkUser.fromJson(json)).toList();
        //     return userItems;
        //   } else {
        //     log('Items key is missing or is null');
        //     return null;
        //   }
        // } else {
        //   log('Unexpected response format: ${data.runtimeType}');
        //   return null;
        // }
      } else {
        log('Failed to fetch user data: ${response.statusCode}');
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

class checkUser {
  final int id; // Add an id field


  checkUser({
    required this.id, // Initialize the id field

  });

  factory checkUser.fromJson(Map<String, dynamic> json) {
    return checkUser(
      id: json['userId'],


    );
  }

}
