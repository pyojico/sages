import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  void onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex.value) return;
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/scan');
        break;
      case 2:
        Navigator.pushNamed(context, '/inventory');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }
}
