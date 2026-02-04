import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:project/resources/resources.dart';

class PegeypayResources {
  static Future<Map<String, dynamic>> getToken({
    required String prefix,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> generateQR({
    required String prefix,
    required Object body,
  }) async {
    final token = await AuthResources.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> refreshToken({
    required String prefix,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return json.decode(response.body) as Map<String, dynamic>;
  }
}
