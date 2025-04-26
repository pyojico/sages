import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> recipe =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['name'] ?? 'Recipe Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe image
            recipe['imgSrc'] != null && recipe['imgSrc'].isNotEmpty
                ? Image.network(
                    recipe['imgSrc'],
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
                    recipe['name'] ?? 'Unknown Recipe',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cooking Time: ${recipe['cooking_time'] ?? 'N/A'} min',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Text(
                    'Servings: ${recipe['servings'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...?recipe['ingredients']?.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('• ${entry.value}'),
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    'Steps:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...?recipe['steps']?.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text('${entry.key + 1}. ${entry.value}'),
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
