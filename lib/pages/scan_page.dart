import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/BottomNav.dart';
import '../widgets/top_nav.dart';
import '../widgets/list-tile_scan.dart';
import '../widgets/dialog.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child("ingredients");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Map<String, dynamic>> foodList = [];
  bool isScanning = false;
  StreamSubscription<DatabaseEvent>? _listenerHandle;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _stopScanning();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      isScanning = true;
      foodList.clear();
    });

    _listenerHandle = _databaseRef.onValue.listen(
      (event) {
        final data = event.snapshot.value;
        if (data != null) {
          List<dynamic> newIngredients = [];
          if (data is Map) {
            final ingredients = data['ingredients'];
            if (ingredients != null && ingredients is Iterable) {
              newIngredients = List.from(ingredients);
            }
          } else if (data is Iterable) {
            newIngredients = List.from(data);
          }

          // 逐個加入新食材到列表頂部
          _addIngredientsWithDelay(newIngredients);
        } else {
          setState(() {
            foodList.clear();
          });
        }
      },
      onError: (error) {
        print("Error: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading data: $error")),
        );
      },
    );
  }

  void _addIngredientsWithDelay(List<dynamic> ingredients) async {
    for (var item in ingredients) {
      await Future.delayed(Duration(seconds: 5)); // 5秒延遲
      if (mounted) {
        setState(() {
          foodList.insert(0, Map<String, dynamic>.from(item)); // 加到頂部
          print("加入食材: ${item['name']}"); // 調試
          _listKey.currentState?.insertItem(
            0, // 插入到頂部
            duration: Duration(milliseconds: 500),
          );
          print("動畫完成: ${item['name']}"); // 調試
        });
      }
    }
  }

  void _stopScanning() {
    if (_listenerHandle != null) {
      _listenerHandle!.cancel();
      _listenerHandle = null;
    }
    setState(() {
      isScanning = false;
    });
  }

  Future<void> _uploadData() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to upload data.')),
      );
      return;
    }

    try {
      for (var foodItem in foodList) {
        if (foodItem is Map<Object?, Object?> &&
            (foodItem['state'] == 'add' || foodItem['state'] == 'return')) {
          Map<String, dynamic> item = foodItem.cast<String, dynamic>();
          if (item['name'] != null && item['name'].isNotEmpty) {
            final docRef = _firestore
                .collection('users')
                .doc(user.uid)
                .collection('inventory')
                .doc(item['name']);
            final docSnapshot = await docRef.get();

            if (docSnapshot.exists) {
              final existingData = docSnapshot.data()!;
              final existingQuantity =
                  (existingData['quantity'] as num?)?.toDouble() ?? 0.0;
              final newQuantity = (item['quantity'] as num?)?.toDouble() ?? 0.0;
              final updatedQuantity = existingQuantity + newQuantity;

              await docRef.set(
                {'quantity': updatedQuantity},
                SetOptions(merge: true),
              );
            } else {
              await docRef.set(item);
            }
          } else {
            print("Invalid food name for item: $item");
          }
        } else {
          print("Invalid data format for item: $foodItem");
        }
      }

      await _databaseRef.remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Data uploaded and deleted successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error uploading data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            TopNav(
              title: '掃描食材',
            ),
            Expanded(
              child: foodList.isEmpty
                  ? const Center(
                      child: Text(
                        '沒有掃描食材\n請按下方按鈕開始掃描',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : AnimatedList(
                      key: _listKey,
                      initialItemCount: foodList.length,
                      itemBuilder: (context, index, animation) {
                        final foodItem = foodList[index];
                        if (foodItem == null) {
                          return const ListTile(
                            title: Text('未知食材'),
                            subtitle: Text('無數據'),
                          );
                        }
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 1.0), // 從底部上滑
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            )),
                            child: ScanListTile(
                              key: Key(foodItem['name']), // 確保動畫穩定
                              foodItem: foodItem,
                              index: index,
                              onTap: () {
                                print("Tapped on ${foodItem['name']}");
                                if (foodItem['state'] == 'error') {
                                  showErrorDialog(context, foodItem);
                                } else {
                                  showEditDialog(
                                      context, foodItem, index, _databaseRef);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (isScanning) {
                    _stopScanning();
                    _uploadData();
                  } else {
                    _startScanning();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Colors.red : Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(isScanning ? '停止掃描' : '開始掃描'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
