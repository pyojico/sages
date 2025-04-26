import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreGetRecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current solar term recipes
  Future<List<Map<String, dynamic>>> getSeasonalRecipes(
      String solarTerm) async {
    try {
      // 優先匹配 solar_terms，後備匹配 season
      final season = getSeasonFromSolarTerm(solarTerm);
      final query = await _firestore
          .collection('recipes')
          .where('solar_terms', isEqualTo: solarTerm)
          .orderBy('likes', descending: true)
          .limit(10)
          .get();

      var recipes = query.docs
          .map((doc) =>
              {'recipe_id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      // 如果少於 10 個，補充 season 匹配的食譜
      if (recipes.length < 10) {
        final additionalQuery = await _firestore
            .collection('recipes')
            .where('season', isEqualTo: season)
            .orderBy('likes', descending: true)
            .limit(10 - recipes.length)
            .get();
        recipes.addAll(additionalQuery.docs.map((doc) =>
            {'recipe_id': doc.id, ...doc.data() as Map<String, dynamic>}));
      }

      // Ensure required fields
      return recipes
          .map((recipe) => {
                'recipe_id': recipe['recipe_id'] ?? '',
                'name': recipe['name'] ?? 'Unknown Recipe',
                'ingredients': recipe['ingredients'] ?? [],
                'cooking_time': recipe['cooking_time'] ?? 0,
                'imgSrc': recipe['imgSrc'] ?? '',
                'likes': recipe['likes'] ?? '0',
                'season': recipe['season'] ?? '',
                'servings': recipe['servings'] ?? 0,
                'solar_terms': recipe['solar_terms'] ?? '',
                'steps': recipe['steps'] ?? [],
                'views': recipe['views'] ?? '0',
              })
          .toList();
    } catch (e) {
      print('Error fetching seasonal recipes: $e');
      throw Exception('Error fetching seasonal recipes: $e');
    }
  }

  // get Popular recipes
  Future<List<Map<String, dynamic>>> getPopularRecipes() async {
    try {
      final query = await _firestore
          .collection('recipes')
          .orderBy('likes', descending: true)
          .limit(10)
          .get();

      var recipes = query.docs
          .map((doc) =>
              {'recipe_id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();

      // Ensure required fields
      return recipes
          .map((recipe) => {
                'recipe_id': recipe['recipe_id'] ?? '',
                'name': recipe['name'] ?? 'Unknown Recipe',
                'ingredients': recipe['ingredients'] ?? [],
                'cooking_time': recipe['cooking_time'] ?? 0,
                'imgSrc': recipe['imgSrc'] ?? '',
                'likes': recipe['likes'] ?? '0',
                'season': recipe['season'] ?? '',
                'servings': recipe['servings'] ?? 0,
                'solar_terms': recipe['solar_terms'] ?? '',
                'steps': recipe['steps'] ?? [],
                'views': recipe['views'] ?? '0',
              })
          .toList();
    } catch (e) {
      print('Error fetching popular recipes: $e');
      throw Exception('Error fetching popular recipes: $e');
    }
  }

  String getSeasonFromSolarTerm(String solarTerm) {
    const seasonMap = {
      '立春': 'spring',
      '雨水': 'spring',
      '驚蟄': 'spring',
      '春分': 'spring',
      '清明': 'spring',
      '穀雨': 'spring',
      '立夏': 'summer',
      '小滿': 'summer',
      '芒種': 'summer',
      '夏至': 'summer',
      '小暑': 'summer',
      '大暑': 'summer',
      '立秋': 'autumn',
      '處暑': 'autumn',
      '白露': 'autumn',
      '秋分': 'autumn',
      '寒露': 'autumn',
      '霜降': 'autumn',
      '立冬': 'winter',
      '小雪': 'winter',
      '大雪': 'winter',
      '冬至': 'winter',
      '小寒': 'winter',
      '大寒': 'winter',
    };
    return seasonMap[solarTerm] ?? 'spring';
  }
}
