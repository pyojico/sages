import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/BottomNav.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _inventoryStream;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // 打印初始用戶狀態
    final user = _auth.currentUser;
    print('InventoryPage initState: user=${user?.uid}');
    if (user != null) {
      _inventoryStream = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('inventory')
          .snapshots();
      print('InventoryPage: Set inventory stream for uid=${user.uid}');
    } else {
      // 延遲 1 秒後檢查 auth 狀態
      Future.delayed(const Duration(seconds: 1), () {
        _auth.authStateChanges().listen((User? user) {
          print('InventoryPage authStateChanges: user=${user?.uid}');
          setState(() {
            if (user != null) {
              _inventoryStream = _firestore
                  .collection('users')
                  .doc(user.uid)
                  .collection('inventory')
                  .snapshots();
              print('InventoryPage: Set inventory stream for uid=${user.uid}');
            } else {
              _inventoryStream = Stream.empty();
              _errorMessage = 'Please sign in to view inventory.';
            }
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: _inventoryStream == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _inventoryStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (_errorMessage != null) {
                  return Center(child: Text(_errorMessage!));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items in inventory.'));
                }

                final inventoryItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: inventoryItems.length,
                  itemBuilder: (context, index) {
                    final foodItem =
                        inventoryItems[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(foodItem['name'] ?? 'Unknown'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity: ${foodItem['quantity'] ?? 'N/A'} ${foodItem['unit'] ?? ''}',
                          ),
                          Text(
                            'Food Type: ${foodItem['foodType'] ?? 'Unknown'}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
