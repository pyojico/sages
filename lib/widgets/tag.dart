import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';

class TagWidget extends StatelessWidget {
  final List<String> tags;

  const TagWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: tags
          .map((tag) => Chip(
                label: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColors.gray800,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ))
          .toList(),
    );
  }
}
