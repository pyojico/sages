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
  List<dynamic> foodList = [];
  String realTimeValue = "No Data";
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
    });

    _listenerHandle = _databaseRef.onValue.listen(
      (event) {
        setState(() {
          final data = event.snapshot.value;
          if (data != null) {
            // 假設 data 係一個 Map，提取 data['ingredients'] 作為 List
            if (data is Map) {
              final ingredients = data['ingredients'];
              if (ingredients != null && ingredients is Iterable) {
                foodList = List.from(ingredients);
              } else {
                foodList.clear();
              }
            } else if (data is Iterable) {
              // 如果 data 係一個 List，直接使用
              foodList = List.from(data);
            } else {
              foodList.clear();
            }
          } else {
            foodList.clear();
          }
        });
      },
      onError: (error) {
        print("Error: $error");
        setState(() {
          realTimeValue = "Error loading data";
        });
      },
    );
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
    try {
      for (var foodItem in foodList) {
        if (foodItem is Map<Object?, Object?> &&
            (foodItem['state'] == 'add' || foodItem['state'] == 'return')) {
          Map<String, dynamic> item = foodItem.cast<String, dynamic>();
          if (user != null) {
            await _firestore
                .collection('users')
                .doc(user.uid)
                .collection('inventory')
                .add(item);
          } else {
            print("User not authenticated");
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
    } catch (e) {
      print("Error: $e");
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
                  : ListView.builder(
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodList[index];
                        if (foodItem == null) {
                          return const ListTile(
                            title: Text('未知食材'),
                            subtitle: Text('無數據'),
                          );
                        }

                        return ScanListTile(
                          foodItem: foodItem,
                          index: index,
                          onTap: () {
                            print("Tapped on ${foodItem['name']}"); // 調試
                            if (foodItem['state'] == 'error') {
                              showErrorDialog(context, foodItem);
                            } else {
                              showEditDialog(
                                  context, foodItem, index, _databaseRef);
                            }
                          },
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
