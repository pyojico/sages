import 'package:flutter/material.dart';
import '../services/ApiService.dart';
import '../services/FirestoreGetRecipeService.dart';
import '../services/FirebaseAuthService.dart';
import '../services/SolarTermService.dart';
import '../services/inventory_service.dart';
import '../widgets/RecipeCard.dart';
import '../widgets/top_nav.dart';
import '../widgets/BottomNav.dart';
import 'package:sages/constants/text_styles.dart';

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
  final InventoryService _inventoryService = InventoryService();

  // 每個分類嘅所有數據
  List<Map<String, dynamic>> allRecommendedRecipes = [];
  List<Map<String, dynamic>> allSeasonalRecipes = [];
  List<Map<String, dynamic>> allPopularRecipes = [];

  // 每個分類目前顯示嘅數據
  List<Map<String, dynamic>> recommendedRecipes = [];
  List<Map<String, dynamic>> seasonalRecipes = [];
  List<Map<String, dynamic>> popularRecipes = [];

  bool isLoading = true;
  String? errorMessage;
  List<String> userInventory = [];

  // 分頁狀態（本地分頁）
  int recommendedDisplayCount = 0;
  int seasonalDisplayCount = 0;
  int popularDisplayCount = 0;
  final int pageSize = 5; // 每次加載 4 個

  // 每個 row 嘅 ScrollController
  final ScrollController _recommendedController = ScrollController();
  final ScrollController _seasonalController = ScrollController();
  final ScrollController _popularController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitialRecipes();

    // 為每個 row 設置滾動監聽
    _recommendedController.addListener(() {
      if (_recommendedController.position.pixels ==
              _recommendedController.position.maxScrollExtent &&
          !isLoading &&
          recommendedDisplayCount < allRecommendedRecipes.length) {
        _loadMoreRecipes('recommended');
      }
    });
    _seasonalController.addListener(() {
      if (_seasonalController.position.pixels ==
              _seasonalController.position.maxScrollExtent &&
          !isLoading &&
          seasonalDisplayCount < allSeasonalRecipes.length) {
        _loadMoreRecipes('seasonal');
      }
    });
    _popularController.addListener(() {
      if (_popularController.position.pixels ==
              _popularController.position.maxScrollExtent &&
          !isLoading &&
          popularDisplayCount < allPopularRecipes.length) {
        _loadMoreRecipes('popular');
      }
    });
  }

  @override
  void dispose() {
    _recommendedController.dispose();
    _seasonalController.dispose();
    _popularController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialRecipes() async {
    if (allRecommendedRecipes.isNotEmpty &&
        allSeasonalRecipes.isNotEmpty &&
        allPopularRecipes.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // 獲取用戶庫存
      userInventory = await _inventoryService.getUserInventory();

      final user = _authService.getCurrentUser();
      if (user != null) {
        allRecommendedRecipes =
            await _apiService.getRecommendedRecipes(user.uid);
        recommendedDisplayCount = 0;
        recommendedRecipes = allRecommendedRecipes.take(pageSize).toList();
        recommendedDisplayCount = recommendedRecipes.length;
      } else {
        allRecommendedRecipes = [];
        recommendedRecipes = [];
        errorMessage = 'Please log in to see recommended recipes';
      }

      final solarTermData = await _solarTermService.getCurrentSolarTerm();
      final currentSolarTerm = solarTermData['solar_term'] as String;
      allSeasonalRecipes =
          await _firestoreService.getSeasonalRecipes(currentSolarTerm);
      seasonalDisplayCount = 0;
      seasonalRecipes = allSeasonalRecipes.take(pageSize).toList();
      seasonalDisplayCount = seasonalRecipes.length;

      allPopularRecipes = await _firestoreService.getPopularRecipes();
      popularDisplayCount = 0;
      popularRecipes = allPopularRecipes.take(pageSize).toList();
      popularDisplayCount = popularRecipes.length;

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

  void _loadMoreRecipes(String category) {
    setState(() {
      isLoading = true;
    });

    try {
      if (category == 'recommended') {
        final nextBatch = allRecommendedRecipes
            .skip(recommendedDisplayCount)
            .take(pageSize)
            .toList();
        setState(() {
          recommendedRecipes.addAll(nextBatch);
          recommendedDisplayCount += nextBatch.length;
        });
      } else if (category == 'seasonal') {
        final nextBatch = allSeasonalRecipes
            .skip(seasonalDisplayCount)
            .take(pageSize)
            .toList();
        setState(() {
          seasonalRecipes.addAll(nextBatch);
          seasonalDisplayCount += nextBatch.length;
        });
      } else if (category == 'popular') {
        final nextBatch =
            allPopularRecipes.skip(popularDisplayCount).take(pageSize).toList();
        setState(() {
          popularRecipes.addAll(nextBatch);
          popularDisplayCount += nextBatch.length;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加載更多食譜失敗：$e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildRecipeRow(
    String title,
    List<Map<String, dynamic>> recipes,
    String category,
    ScrollController controller,
    int displayCount,
    List<Map<String, dynamic>> allRecipes,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (recipes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '未有符合的食譜，試試加入食材到你的雪櫃吧！',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          SizedBox(
            height: 320,
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount:
                  recipes.length + (displayCount < allRecipes.length ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == recipes.length) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/recipe_detail',
                      arguments: {
                        'recipe': recipes[index],
                        'userInventory': userInventory, // 傳入 userInventory
                      },
                    );
                  },
                  child: RecipeCard(
                    recipe: recipes[index],
                    isVertical: false,
                    userInventory: userInventory,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopNav(
              title: '尋找適合的烹飪食譜',
              // onSearchPressed: () {
              //   // TODO: 實現搜索功能
              // },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchInitialRecipes,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchInitialRecipes,
                                  child: const Text('重試'),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                _buildRecipeRow(
                                  '根據庫存的食材',
                                  recommendedRecipes,
                                  'recommended',
                                  _recommendedController,
                                  recommendedDisplayCount,
                                  allRecommendedRecipes,
                                ),
                                _buildRecipeRow(
                                  '精選應節食譜',
                                  seasonalRecipes,
                                  'seasonal',
                                  _seasonalController,
                                  seasonalDisplayCount,
                                  allSeasonalRecipes,
                                ),
                                _buildRecipeRow(
                                  '熱門食譜',
                                  popularRecipes,
                                  'popular',
                                  _popularController,
                                  popularDisplayCount,
                                  allPopularRecipes,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
