import 'package:flutter/material.dart';

class AppColors {
  // 主色與強調色
  static const Color green = Color(0xFFC5D937); // 主綠色
  static const Color greyBlue = Color.fromARGB(255, 138, 177, 180); // 灰藍色
  static const Color red = Color(0xFFDE5151); // 紅色

  // 灰色階梯
  static const Color gray100 = Color(0xFFEEEEEE);
  static const Color gray200 = Color(0xFFD7D7D7);
  static const Color gray300 = Color(0xFFBEBEBE);
  static const Color gray500 = Color(0xFF8C8C8C);
  static const Color gray800 = Color.fromARGB(255, 59, 59, 59);

  // 語義色 (可選)
  static const Color error = red;
  static const Color success = green;
  static const Color disabled = gray500;

  // 文字顏色
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = gray500;

  // 背景色
  static const Color background = Colors.white;
  static const Color surface = gray100;
}
