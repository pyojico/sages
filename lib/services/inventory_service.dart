import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> getUserInventory() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('用戶未登錄');
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('inventory')
          .get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      // 提取庫存食材名稱
      final inventoryItems = snapshot.docs
          .map((doc) => doc.data()['name'] as String? ?? 'Unknown')
          .toList();

      return inventoryItems;
    } catch (e) {
      throw Exception('無法獲取庫存：$e');
    }
  }
}
