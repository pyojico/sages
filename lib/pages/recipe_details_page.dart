import 'package:flutter/material.dart';
import 'package:sages/widgets/tag.dart';
import 'package:sages/widgets/infoDetails.dart';
import 'package:sages/constants/colors.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  List<String> _generateTags(Map<String, dynamic> recipe) {
    List<String> tags = [];
    final String name = recipe['name'] ?? '';
    final String solarTerm = recipe['solar_terms'] ?? '';
    final String season = recipe['season'] ?? '';

    if (name.contains('湯')) {
      tags.add('湯類');
    }
    if (name.contains('雞')) {
      tags.add('雞肉');
    }
    if (solarTerm.isNotEmpty) tags.add(solarTerm);
    if (season.isNotEmpty) tags.add(season);

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Map<String, dynamic> recipe =
        arguments['recipe'] as Map<String, dynamic>;
    final List<String> userInventory =
        arguments['userInventory'] as List<String>;

    final String name = recipe['name'] ?? 'Unknown Recipe';
    final String imgSrc = recipe['imgSrc'] ?? '';
    final int cookingTime = recipe['cooking_time'] ?? 0;
    final int servings = recipe['servings'] ?? 0;
    final int stepTotal = recipe['steps']?.length ?? 0;
    final List<String> ingredients =
        List<String>.from(recipe['ingredients'] ?? []);
    final int ingredientCount = ingredients.length;
    final List<String> steps = List<String>.from(recipe['steps'] ?? []);

    final List<String> tags = _generateTags(recipe);
    final int inventoryMatch = ingredients
        .where((ingredient) => userInventory.contains(ingredient))
        .length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(), // 移除標題
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            imgSrc.isNotEmpty
                ? Image.network(
                    imgSrc,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/recipe-alt.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    'assets/images/recipe-alt.png',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            // Recipe details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TagWidget(tags: tags),
                  const SizedBox(height: 8),
                  InfoDetail(
                    cookingTime: cookingTime,
                    servings: servings,
                    stepTotal: stepTotal,
                    inventoryMatch: inventoryMatch,
                    ingredientCount: ingredientCount,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '食材：',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...ingredients.map((ingredient) {
                    final bool inInventory = userInventory.contains(ingredient);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            '• $ingredient',
                            style: TextStyle(
                              color: inInventory ? Colors.green : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          if (inInventory) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    '步驟：',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...steps.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${entry.key + 1}. ${entry.value}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
