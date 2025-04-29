import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  static const String _baseUrl =
      'https://us-central1-sages-79fb7.cloudfunctions.net';

  Future<List<Map<String, dynamic>>> getRecommendedRecipes(
      String userId) async {
    // Check network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/recommendation'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      )
          .timeout(Duration(seconds: 90), onTimeout: () {
        throw Exception('Request timed out after 90 seconds');
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data.containsKey('message')) {
          print('No recommended recipes: ${data['message']}');
          return [];
        } else {
          throw Exception('Unexpected response format: $data');
        }
      } else {
        throw Exception(
            'Failed to load recommended recipes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching recommended recipes: $e');
      throw Exception('Error fetching recommended recipes: $e');
    }
  }
}
