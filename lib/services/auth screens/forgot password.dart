import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_list.dart';

Future<Map<String, dynamic>> forgotPassword(String phoneNumber) async {
  final url = Uri.parse(ApiList.forgotPassword!);
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'number': phoneNumber}),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      /// Important
      print('Error: ${response.statusCode} - ${response.body}');
      return {'status': false, 'message': 'Error occurred'};
    }
  } catch (error) {
    // Handle exceptions
    print('Error: $error');
    return {'status': false, 'message': error.toString()};
  }
}
