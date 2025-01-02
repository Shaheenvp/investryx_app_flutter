import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import flutter_secure_storage
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../api_list.dart';

class BusinessAddPage {
  static var client = http.Client();
  static final storage =
  FlutterSecureStorage(); // Create an instance of FlutterSecureStorage

  static Future<bool?> businessAddPage({
    required String name,
    required String singleLineDescription,
    required String industry,
    required String establish_yr,
    required String description,
    required String address_1,
    required String address_2,
    required String state,
    required String pin,
    required String city,
    required String employees,
    required String entity,
    required String avg_monthly,
    required String latest_yearly,
    required String ebitda,
    required String rate,
    required String type_sale,
    required String url,
    required String top_selling,
    required String features,
    required String facility,
    required String reason,
    required String income_source,
    File? image1,
    File? image2,
    File? image3,
    File? image4,
    File? doc1,
    File? proof1,
    required BuildContext context,
    required String minimumRange,
    required String maximumRange,
    required String askingPrice,
  }) async {
    try {
      // Retrieve the token from FlutterSecureStorage
      String? token = await storage.read(key: 'token');
      if (token == null) {
        log('Error: Token not found in Flutter Secure Storage');
        return false;
      }

      // Create multipart request
      var request =
      http.MultipartRequest('POST', Uri.parse(ApiList.businessAddPage!));
      request.fields['name'] = name;
      request.fields['single_desc'] = singleLineDescription;
      request.fields['industry'] = industry;
      request.fields['establish_yr'] = establish_yr;
      request.fields['description'] = description;
      request.fields['address_1'] = address_1;
      request.fields['address_2'] = address_2;
      request.fields['state'] = state;
      request.fields['pin'] = pin;
      request.fields['city'] = city;
      request.fields['employees'] = employees;
      request.fields['entity'] = entity;
      request.fields['avg_monthly'] = avg_monthly;
      request.fields['latest_yearly'] = latest_yearly;
      request.fields['ebitda'] = ebitda;
      request.fields['range_starting'] = rate;
      request.fields['type_sale'] = type_sale;
      request.fields['url'] = url;
      request.fields['top_selling'] = top_selling;
      request.fields['features'] = features;
      request.fields['facility'] = facility;
      request.fields['reason'] = reason;
      request.fields['income_source'] = income_source;
      request.fields["range_ending"] = maximumRange;
      request.fields["range_starting"] = minimumRange;
      request.fields["asking_price"] = askingPrice ?? "";

      // Add Authorization header with the token
      request.headers['token'] = token;
      // Add files to the request
      if (image1 != null &&
          image2 != null &&
          image3 != null &&
          image4 != null &&
          doc1 != null &&
          proof1 != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image1', image1.path,
            filename: basename(image1.path)));
        request.files.add(await http.MultipartFile.fromPath(
            'image2', image2.path,
            filename: basename(image2.path)));
        request.files.add(await http.MultipartFile.fromPath(
            'image3', image3.path,
            filename: basename(image3.path)));
        request.files.add(await http.MultipartFile.fromPath(
            'image4', image4.path,
            filename: basename(image4.path)));
        request.files.add(await http.MultipartFile.fromPath('doc1', doc1.path,
            filename: basename(doc1.path)));
        request.files.add(await http.MultipartFile.fromPath(
            'proof1', proof1.path,
            filename: basename(proof1.path)));
      }
      // log('Image1 path: ${image1.path}');
      // log('Doc1 path: ${doc1.path}');
      // log('Proof1 path: ${proof1.path}');

      // Send the request
      var response = await request.send();
      print('Response of add business post: ${response.statusCode}');
      print(await response.stream.bytesToString());

      // Handle the response
      if (response.statusCode == 201) {
        log('File uploaded successfully!');

        return true;
      } else {
        log('Failed to upload file: ${response.statusCode}');

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