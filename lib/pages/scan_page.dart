import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../widgets/BottomNav.dart';

class ScanPage extends StatefulWidget {
  ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(1);
  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child("ingredients");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<dynamic> foodList = [];
  String realTimeValue = "No Data";

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/inventory');
    } else if (index == 3) {
      Navigator.pushNamed(context, '/profile');
    } else {
      _selectedIndex.value = index;
    }
  }

  @override
  void initState() {
    super.initState();
    _databaseRef.onValue.listen(
      (event) {
        setState(() {
          final data = event.snapshot.value;
          if (data != null) {
            foodList = List.from(data as Iterable<dynamic>);
          } else {
            setState(() {
              foodList.clear();
            });
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

  Future<void> _uploadData() async {
    try {
      for (var foodItem in foodList) {
        if (foodItem is Map<Object?, Object?>) {
          Map<String, dynamic> item = foodItem.cast<String, dynamic>();
          await _firestore.collection('inventory').add(item);
        } else {
          print("Invalid data format for item: $foodItem");
        }
      }

      await _databaseRef.remove();

      // 顯示成功消息
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data uploaded and deleted successfully!"),
      ));
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error uploading data: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
      ),
      body: Center(
        child: foodList.isEmpty
            ? const Text(
                'No items found. Please scan items.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: foodList.length,
                      itemBuilder: (context, index) {
                        final foodItem = foodList[index];
                        if (foodItem == null) {
                          return ListTile(
                            title: Text('Unknown Item'),
                            subtitle: Text('No data available'),
                          );
                        }
                        return ListTile(
                          title: Text(foodItem['name'] ?? 'Unknown'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quantity: ${foodItem['quantity']} ${foodItem['unit']}',
                              ),
                              Text(
                                'Food Type: ${foodItem['foodType'] ?? 'Unknown'}',
                                style: TextStyle(color: Colors.grey), // 可選的樣式
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _uploadData,
                    child: const Text('Confirm'),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
