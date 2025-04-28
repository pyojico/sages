import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/form_container_widget.dart';
import '../widgets/top_nav_center.dart';
import 'profile_init_2.dart'; // 跳過 ProfileInit1
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';

class ProfileInit0 extends StatefulWidget {
  final bool fromSignUp;

  const ProfileInit0({super.key, required this.fromSignUp});

  @override
  _ProfileInit0State createState() => _ProfileInit0State();
}

class _ProfileInit0State extends State<ProfileInit0> {
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
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'username': _usernameController.text.isEmpty
            ? 'User${user.uid.substring(0, 5)}'
            : _usernameController.text,
        'avatar': _selectedAvatar,
      }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileInit2(fromSignUp: widget.fromSignUp)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildSection() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 垂直置中
        crossAxisAlignment: CrossAxisAlignment.center, // 水平置中
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.center, // Wrap 內部內容也置中
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
                title: '設置你的個人檔案',
                currentStep: 1,
                totalSteps: 4,
                content: '選擇你的頭像和稱呼',
              ),
              const SizedBox(height: 40),
              Expanded(child: _buildSection()),
              _buildCustomButton('下一步', _saveProfile),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileInit2(fromSignUp: widget.fromSignUp)),
                ),
                child: const Text('略過'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
