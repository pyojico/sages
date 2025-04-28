import 'package:flutter/material.dart';
import 'package:sages/constants/text_styles.dart';

class TopNav extends StatelessWidget {
  final String title;
  final Widget? action;

  const TopNav({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          if (action != null) action!, // 顯示傳入嘅 action，如果為 null 則唔顯示
        ],
      ),
    );
  }
}
