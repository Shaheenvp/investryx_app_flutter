import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
import '../api_list.dart';

Future<bool> signIn(String username, String password) async {
  final url = Uri.parse(ApiList.login!);
  try {
    final client = http.Client();
    final response = await client.post(
      url,
      body: json.encode({'phone': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    /// Important
    print('Response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      final statusMap = jsonDecode(response.body);
      bool status = statusMap['status'];

      // Assuming token is received instead of userId
      String? token = statusMap['token'];

      if (status && token != null) {
        // Initialize secure storage
        final storage = FlutterSecureStorage();

        // Save token to Flutter secure storage
        await storage.write(key: 'token', value: token);

        // Retrieve and print the saved token
        String? savedToken = await storage.read(key: 'token');
        print('Saved token: $savedToken'); // Print the saved token

        return true;
      } else {
        return false;
      }
    } else {
      // Handle non-200 status codes (e.g., show an error message)
      print('Error: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (error) {
    // Handle exceptions
    print('Error: $error');
    return false;
  }
}
