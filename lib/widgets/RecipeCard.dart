import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';
import 'package:sages/widgets/tag.dart';
import 'package:sages/widgets/infoDetails.dart';

class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipe;
  final bool isVertical;
  final List<String> userInventory; // 新增參數

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isVertical = false,
    required this.userInventory, // 新增參數
  });

  List<String> _generateTags(String recipeName) {
    List<String> tags = [];
    if (recipeName.contains('湯')) {
      tags.add('湯類');
    }
    if (recipeName.contains('雞')) {
      tags.add('雞肉');
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final String name = recipe['name'] ?? 'Unknown Recipe';
    final String imgSrc = recipe['imgSrc'] ?? '';
    final int cookingTime = recipe['cooking_time'] ?? 0;
    final int servings = recipe['servings'] ?? 0;
    final int stepTotal = recipe['steps']?.length ?? 0;
    final List<String> ingredients =
        List<String>.from(recipe['ingredients'] ?? []);
    final int ingredientCount = ingredients.length;
    final String solarTerm = recipe['solar_terms'] ?? '';
    final String season = recipe['season'] ?? '';

    List<String> tags = _generateTags(name);
    if (solarTerm.isNotEmpty) tags.add(solarTerm);
    if (season.isNotEmpty) tags.add(season);

    final int inventoryMatch = ingredients
        .where((ingredient) => userInventory.contains(ingredient))
        .length;

    return Container(
      width: isVertical ? double.infinity : 240,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: isVertical
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    child: imgSrc.isNotEmpty
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/images/recipe-alt.png',
                            image: imgSrc,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/recipe-alt.png',
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/recipe-alt.png',
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppTextSizes.bodyLarge,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          TagWidget(tags: tags),
                          const SizedBox(height: 4),
                          InfoDetail(
                            cookingTime: cookingTime,
                            servings: servings,
                            stepTotal: stepTotal,
                            inventoryMatch: inventoryMatch,
                            ingredientCount: ingredientCount,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    child: imgSrc.isNotEmpty
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/images/recipe-alt.png',
                            image: imgSrc,
                            height: 160,
                            width: 240,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/recipe-alt.png',
                              height: 160,
                              width: 240,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/recipe-alt.png',
                            height: 160,
                            width: 240,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppTextSizes.bodyLarge,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        TagWidget(tags: tags),
                        const SizedBox(height: 4),
                        InfoDetail(
                          cookingTime: cookingTime,
                          servings: servings,
                          stepTotal: stepTotal,
                          inventoryMatch: inventoryMatch,
                          ingredientCount: ingredientCount,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
