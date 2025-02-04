import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(2);
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String _message = "No Data";

  @override
  void initState() {
    super.initState();
    _databaseReference.child('food').onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        _message = data.toString();
      });
    });
  }

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Center(
        child: Text(
          _message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
                icon: Icon(Icons.business),
                label: 'Business',
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
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: const TextStyle(fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontSize: 14),
            onTap: _onItemTapped,
          );
        },
      ),
    );
  }
}
