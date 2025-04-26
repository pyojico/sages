import 'package:flutter/material.dart';
import '../services/ApiService.dart';
import '../services/FirestoreGetRecipeService.dart';
import '../services/FirebaseAuthService.dart';
import '../services/SolarTermService.dart';
import '../widgets/RecipeCard.dart';
import '../widgets/BottomNav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final ApiService _apiService = ApiService();
  final FirestoreGetRecipeService _firestoreService =
      FirestoreGetRecipeService();
  final SolarTermService _solarTermService = SolarTermService();

  List<Map<String, dynamic>> recommendedRecipes = [];
  List<Map<String, dynamic>> seasonalRecipes = [];
  List<Map<String, dynamic>> popularRecipes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  // Get different type of recipes
  Future<void> _fetchRecipes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // recommendated recipes
      final user = _authService.getCurrentUser();
      const String testUserId = '48iEOW92z7Q1Ax5yHScLg9liO5K2';
      if (user != null) {
        recommendedRecipes =
            await _apiService.getRecommendedRecipes(testUserId);
        recommendedRecipes = recommendedRecipes.take(10).toList();
      } else {
        recommendedRecipes = [];
        errorMessage = 'Please log in to see recommended recipes';
      }

      // current solar term recipes
      final solarTermData = await _solarTermService.getCurrentSolarTerm();
      final currentSolarTerm = solarTermData['solar_term'] as String;
      seasonalRecipes =
          await _firestoreService.getSeasonalRecipes(currentSolarTerm);
      seasonalRecipes = seasonalRecipes.take(10).toList();

      // Popular recipes
      popularRecipes = await _firestoreService.getPopularRecipes();
      popularRecipes = popularRecipes.take(10).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load recipes: $e';
      });
    }
  }

  Widget _buildRecipeRow(
      String title, List<Map<String, dynamic>> recipes, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (recipes.length > 3)
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/recipe_list',
                      arguments: {'category': category, 'recipes': recipes},
                    );
                  },
                  child: const Text('See More'),
                ),
            ],
          ),
        ),
        if (recipes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'No matching recipes found. Try adding more ingredients to your inventory!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length > 3 ? 3 : recipes.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/recipe_detail',
                    arguments: recipes[index],
                  );
                },
                child: RecipeCard(recipe: recipes[index]),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Hub'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRecipes,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage!,
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchRecipes,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildRecipeRow('Recommended for You',
                            recommendedRecipes, '根據庫存食材推薦'),
                        _buildRecipeRow(
                            'Seasonal Picks', seasonalRecipes, '精選應節食譜'),
                        _buildRecipeRow(
                            'Popular Recipes', popularRecipes, '熱門食譜'),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
