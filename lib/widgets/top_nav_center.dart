import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';

class TopNavCenter extends StatelessWidget {
  final String title;
  final int currentStep;
  final int totalSteps;
  final String content;
  final VoidCallback? onBackPressed; // 返回按鈕回調

  const TopNavCenter({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    required this.content,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 154,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              if (onBackPressed != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: onBackPressed,
                )
              else
                const SizedBox(width: 48), // 佔位，保持置中
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48), // 佔位，保持置中
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: index + 1 == currentStep
                      ? AppColors.green
                      : AppColors.gray200,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
