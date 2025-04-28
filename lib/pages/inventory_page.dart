import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/BottomNav.dart';
import '../widgets/top_nav.dart';
import '../widgets/dialog.dart';

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

  // 處理添加新食材
  void _addNewItem() {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to add items.')),
      );
      return;
    }

    showAddDialog(
      context,
      onSave: (newItem) async {
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('inventory')
              .add(newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully!')),
          );
        } catch (e) {
          print("Error adding item: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding item: $e')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopNav(
              title: '雪櫃庫存',
              action: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _addNewItem,
              ),
            ),
            Expanded(
              child: _inventoryStream == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<QuerySnapshot>(
                      stream: _inventoryStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (_errorMessage != null) {
                          return Center(child: Text(_errorMessage!));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('沒有庫存！快啲入貨'));
                        }

                        final inventoryItems = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: inventoryItems.length,
                          itemBuilder: (context, index) {
                            final foodItem = inventoryItems[index].data()
                                as Map<String, dynamic>;
                            return ListTile(
                              title: Text(foodItem['name'] ?? 'Unknown'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '數量: ${foodItem['quantity'] ?? 'N/A'} ${foodItem['unit'] ?? ''}',
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        '類別: ${foodItem['foodType'] ?? 'Unknown'}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
