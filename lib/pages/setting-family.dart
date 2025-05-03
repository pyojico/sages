import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import '../widgets/form_container_widget.dart';
import '../widgets/top_nav_center.dart';
import 'profile_page.dart';

class Setting2 extends StatefulWidget {
  const Setting2({super.key});

  @override
  _Setting2State createState() => _Setting2State();
}

class _Setting2State extends State<Setting2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _familyNameController = TextEditingController();
  bool _hasFamilyId = false;
  String? _existingFamilyId;
  String _existingFamilyName = '';
  bool _selectedFamily = false;

  @override
  void initState() {
    super.initState();
    _familyNameController.text = '我們這一家'; // 設置預設值
    _checkFamilyId();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  void _checkFamilyId() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 檢查用戶是否加入家庭
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('family')
          .get();
      if (doc.exists && doc.data()?['fid'] != null) {
        final fid = doc.data()!['fid'] as String;
        final familyDoc =
            await _firestore.collection('families').doc(fid).get();
        if (familyDoc.exists) {
          final data = familyDoc.data();
          setState(() {
            _hasFamilyId = true;
            _existingFamilyId = fid;
            _existingFamilyName = data != null && data['name'] != null
                ? data['name'].toString()
                : '未知家庭';
            _selectedFamily = true; // 默認選擇現有家庭
          });
        }
      }
    } catch (e) {
      print("檢查家庭失敗: $e");
    }
  }

  void _joinFamily() async {
    final user = _auth.currentUser;
    if (user == null || _existingFamilyId == null) return;

    try {
      // 更新 families/{fid}/users，加入 uid
      await _firestore.collection('families').doc(_existingFamilyId).set(
        {
          'users': FieldValue.arrayUnion([user.uid]),
        },
        SetOptions(merge: true),
      );

      // 儲存 fid 和 name 到 users/{uid}/info/family
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('family')
          .set({
        'fid': _existingFamilyId,
        'name': _existingFamilyName,
      }, SetOptions(merge: true));

      // 跳轉 ProfilePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('加入家庭失敗: $e')));
    }
  }

  void _createFamily() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 建立新家庭
      final newFamily = await _firestore.collection('families').add({
        'name': _familyNameController.text.isEmpty
            ? '我們這一家'
            : _familyNameController.text,
        'users': [user.uid],
      });

      // 儲存 fid 和 name 到 users/{uid}/info/family
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('family')
          .set({
        'fid': newFamily.id,
        'name': _familyNameController.text.isEmpty
            ? '我們這一家'
            : _familyNameController.text,
      }, SetOptions(merge: true));

      // 跳轉 ProfilePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('建立家庭失敗: $e')));
    }
  }

  Widget _buildSection() {
    if (_hasFamilyId) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '你的家庭：',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            _existingFamilyName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: _selectedFamily,
                onChanged: (value) {
                  setState(() {
                    _selectedFamily = value ?? false;
                  });
                },
              ),
              const Text('加入此家庭', style: TextStyle(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          const Text('建立新家庭？', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          FormContainerWidget(
            controller: _familyNameController,
            hintText: '家庭名稱',
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('建立新家庭？', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          FormContainerWidget(
            controller: _familyNameController,
            hintText: '家庭名稱',
          ),
        ],
      );
    }
  }

  Widget _buildCustomButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () {
        if (_hasFamilyId && _selectedFamily) {
          _joinFamily();
        } else {
          _createFamily();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TopNavCenter(
                title: '建立家庭計劃',
                currentStep: 2,
                totalSteps: 2,
                content: '共享家庭雪櫃庫存',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton('完成', _createFamily),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
                child: const Text(
                  '稍後加入',
                  style: TextStyle(
                    color: AppColors.gray500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
