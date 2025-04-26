import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class SolarTermService {
  static const String _baseUrl =
      'https://us-central1-sages-79fb7.cloudfunctions.net';

  Future<Map<String, dynamic>> getCurrentSolarTerm() async {
    // Check network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    // Fetch the current solar term from the API
    try {
      final response = await http.get(Uri.parse('$_baseUrl/solarTerm'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data.containsKey('solar_term') && data.containsKey('season')) {
          return data;
        } else {
          throw Exception('Invalid solar term response: $data');
        }
      } else {
        throw Exception(
            'Failed to load solar term: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching solar term: $e');
      throw Exception('Error fetching solar term: $e');
    }
  }
}
