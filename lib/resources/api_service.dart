import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';

class ApiService {
  Future<Map<String, dynamic>> getLatestLprEvent() async {
    // Note: In production, you'd ideally pass the plate number as a query param
    final uri =
        Uri.parse("${ApiEndpoints.lprEvents}?start=2025-01-01&end=2025-12-31");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List list = json.decode(response.body);
        if (list.isEmpty) throw Exception("No events found");
        return list.last as Map<String, dynamic>;
      } else {
        throw Exception("Failed to fetch LPR event");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getParkingInfoByLatLng(
      double lat, double lng) async {
    final uri = Uri.parse("${ApiEndpoints.parkingByLatLng}?lat=$lat&lng=$lng");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch parking info");
    }
  }
}
