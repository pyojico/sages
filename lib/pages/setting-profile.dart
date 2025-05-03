import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sages/pages/profile_page.dart';
import '../widgets/form_container_widget.dart';
import '../widgets/top_nav_center.dart';
import 'profile_init_2.dart';
import 'package:sages/constants/colors.dart';

class Setting1 extends StatefulWidget {
  @override
  _Setting1State createState() => _Setting1State();
}

class _Setting1State extends State<Setting1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _usernameController = TextEditingController();
  String _selectedAvatar = '👨‍🦳'; // 默認頭像
  final Map<String, String> _avatars = {
    '👨‍🦳': '爸',
    '👩‍🦳': '媽',
    '👦': '兒',
    '👧': '女',
    '👵': '嬤',
    '👴': '爺',
  };

  @override
  void initState() {
    super.initState();
    _loadProfile(); // 進入時讀取 Firestore 資料
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('details')
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _selectedAvatar = data['avatar'] ?? '👨‍🦳';
          _usernameController.text = data['name'] ?? '';
        });
      }
    } catch (e) {
      print("讀取用戶資料失敗: $e");
    }
  }

  void _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('details')
          .set({
        'avatar': _selectedAvatar,
        'name': _usernameController.text.isEmpty
            ? 'User${user.uid.substring(0, 5)}'
            : _usernameController.text,
      }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildSection() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center,
            children: _avatars.entries.map((entry) {
              final emoji = entry.key;
              final label = entry.value;
              final isSelected = _selectedAvatar == emoji;
              return GestureDetector(
                onTap: () => setState(() => _selectedAvatar = emoji),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Text(emoji, style: const TextStyle(fontSize: 80)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          FormContainerWidget(
            controller: _usernameController,
            hintText: '稱呼',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
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
                title: '個人資料',
                currentStep: 1,
                totalSteps: 4,
                content: '選擇你的頭像和稱呼',
              ),
              const SizedBox(height: 40),
              Expanded(child: _buildSection()),
              _buildCustomButton('完成', _saveProfile),
            ],
          ),
        ),
      ),
    );
  }
}
