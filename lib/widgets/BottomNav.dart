import 'package:flutter/material.dart';
import '../services/NavigationService.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationService = NavigationService();
    return ValueListenableBuilder<int>(
      valueListenable: navigationService.selectedIndex,
      builder: (context, value, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '食譜',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '掃描',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory),
              label: '雪櫃',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '個人',
            ),
          ],
          currentIndex: value,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          onTap: (index) => navigationService.onItemTapped(context, index),
        );
      },
    );
  }
}
