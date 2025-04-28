import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';

class InfoDetail extends StatelessWidget {
  final int cookingTime;
  final int servings;
  final int stepTotal;
  final int inventoryMatch;
  final int ingredientCount;

  const InfoDetail({
    super.key,
    required this.cookingTime,
    required this.servings,
    required this.stepTotal,
    required this.inventoryMatch,
    required this.ingredientCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // 子元素之間嘅水平間距
      runSpacing: 4, // 換行時嘅垂直間距
      children: [
        // Cooking Time
        Row(
          mainAxisSize: MainAxisSize.min, // 讓 Row 只佔必要空間
          children: [
            Image.asset(
              'assets/icons/timer.png', // 修正為 PNG 格式
              width: 14,
              height: 14,
              color: AppColors.gray500,
            ),
            const SizedBox(width: 2),
            Text(
              '$cookingTime 分鐘',
              style: const TextStyle(
                  fontSize: AppTextSizes.bodySmall, color: AppColors.gray500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        // Servings
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/profile.png',
              width: 14,
              height: 14,
              color: AppColors.gray500,
            ),
            const SizedBox(width: 2),
            Text(
              '$servings 人份',
              style: const TextStyle(
                  fontSize: AppTextSizes.bodySmall, color: AppColors.gray500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        // Steps
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/list.png',
              width: 14,
              height: 14,
              color: AppColors.gray500,
            ),
            const SizedBox(width: 2),
            Text(
              '$stepTotal 步驟',
              style: const TextStyle(
                  fontSize: AppTextSizes.bodySmall, color: AppColors.gray500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        // Ingredients Match
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/checkmark.png',
              width: 14,
              height: 14,
              color: AppColors.gray500,
            ),
            const SizedBox(width: 2),
            Text(
              '$inventoryMatch/$ingredientCount 食材',
              style: const TextStyle(
                  fontSize: AppTextSizes.bodySmall, color: AppColors.gray500),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
