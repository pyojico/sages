import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // 標題類
  static TextStyle headlineLarge(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        );
  }

  // 正文類
  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.textPrimary,
        );
  }

  // 功能類文字
  static TextStyle button(BuildContext context) {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.2,
    );
  }

  static TextStyle input(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      color: AppColors.textPrimary,
    );
  }

  // 狀態文字
  static TextStyle error(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          color: AppColors.red,
        );
  }

  static TextStyle success(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: AppColors.green,
        );
  }

  static TextStyle label(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          color: AppColors.green,
        );
  }

  // 快速生成帶顏色的文字樣式
  static TextStyle withColor(
    BuildContext context, {
    required Color color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize ?? AppTextSizes.bodyMedium,
      fontWeight: fontWeight,
    );
  }
}

// 尺寸定義（供內部使用）
class AppTextSizes {
  static const double displayLarge = 28;
  static const double displayMedium = 20;
  static const double bodyLarge = 18;
  static const double bodyMedium = 16;
  static const double bodySmall = 14;
  static const double labelSmall = 12;
}
