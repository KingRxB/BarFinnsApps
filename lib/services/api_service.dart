import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with the NEW URL provided
  static const String _baseUrl =
      'YOUR_GOOGLE_APPS_SCRIPT_URL_HERE';

  Future<Map<String, dynamic>> getAllData({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final startStr = startDate.toIso8601String().split('T')[0];
    final endStr = endDate.toIso8601String().split('T')[0];
    
    final uri = Uri.parse('$_baseUrl?v=json&action=getAllData&start=$startStr&end=$endStr');
    
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if (response.body.contains("<!DOCTYPE html>")) {
         throw Exception("Received HTML instead of JSON. Check the Script Deployment permissions.");
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> addTransaction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 302) {
       // Google Scripts sometimes redirect on success
       return true; 
    } else {
      throw Exception('Failed to save data. Code: ${response.statusCode}');
    }
  }
}
