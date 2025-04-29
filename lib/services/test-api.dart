import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiService {
  static const String _baseUrl =
      'https://us-central1-sages-79fb7.cloudfunctions.net';

  Future<List<Map<String, dynamic>>> getRecommendedRecipes(
      String userId) async {
    // Demo用mock數據，避開API 504 Timeout
    await Future.delayed(Duration(seconds: 1)); // 模擬網絡延遲
    return [
      {
        'recipe_id': '1',
        'name': '辣雞炒飯',
        'ingredients': ['雞肉', '米', '辣椒'],
        'solar_terms': '立春',
        'season': 'spring',
        'cooking_time': 20,
        'servings': 2,
        'steps': ['炒雞肉', '加米飯', '調味'],
        'imgSrc': 'https://example.com/spicy_chicken_rice.jpg',
        'likes': 100,
        'views': 500
      },
      {
        'recipe_id': '2',
        'name': '紅蘿蔔排骨湯',
        'ingredients': ['排骨', '紅蘿蔔', '薑'],
        'solar_terms': '立春',
        'season': 'spring',
        'cooking_time': 60,
        'servings': 4,
        'steps': ['燉排骨', '加紅蘿蔔', '慢煮'],
        'imgSrc': 'https://example.com/carrot_rib_soup.jpg',
        'likes': 80,
        'views': 300
      },
      {
        'recipe_id': '3',
        'name': '金針菇炒雞肉',
        'ingredients': ['雞肉', '金針菇', '薑'],
        'solar_terms': '立春',
        'season': 'spring',
        'cooking_time': 15,
        'servings': 2,
        'steps': ['炒雞肉', '加金針菇', '調味'],
        'imgSrc': 'https://example.com/enoki_chicken.jpg',
        'likes': 120,
        'views': 600
      }
    ];

    // 真API代碼（Demo後可切回）
    /*
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
    */
  }
}
