import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home Page'),
    Text('Business Page'),
    Text('School Page'),
    Text('Settings Page'),
  ];

  void _onItemTapped(BuildContext context, int index) {
    if (index == 2) {
      Navigator.pushNamed(context, '/inventory');
    } else {
      _selectedIndex.value = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text("Welcome Home",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
            child: Container(
              height: 45,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, value, child) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Inventory',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: value,
            selectedItemColor: Colors.black, // Set the color for selected items
            unselectedItemColor: Colors.grey,
            selectedLabelStyle:
                const TextStyle(fontSize: 14), // Prevent text scaling
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            onTap: (index) => _onItemTapped(context, index),
          );
        },
      ),
    );
  }
}
