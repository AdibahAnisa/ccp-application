import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/constant.dart';
import 'package:project/resources/resources.dart';

class ReloadResources {
  static Future<Map<String, dynamic>> reloadMoneyPageypay({
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

  static Future<Map<String, dynamic>> reloadMoneyFPX({
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

  static Future<Map<String, dynamic>> reloadProcess({
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

  static Future<Map<String, dynamic>> reloadSuccessful({
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
}
