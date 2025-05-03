import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/pages/profile_page.dart';
import '../widgets/top_nav_center.dart';
import 'profile_init_3.dart';

class Setting4 extends StatefulWidget {
  @override
  _Setting4State createState() => _Setting4State();
}

class _Setting4State extends State<Setting4> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _foodTypes = [
    '雞肉',
    '排骨',
    '鳳梨',
    '蘆筍',
    '老菜脯',
    '蔬果',
    '水果',
    '素食',
    '湯類'
  ];
  final List<String> _seasons = ['春季', '夏季', '秋季', '冬季'];
  final List<String> _selectedFoodTypes = [];
  final List<String> _selectedSeasons = [];

  void _savePreferences() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 合併食材和季節為單一 List<String>
      final List<String> preferences = [
        ..._selectedFoodTypes,
        ..._selectedSeasons
      ];

      // 儲存為 Map，包含 items 字段
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('profile')
          .doc('preferences')
          .set({
        'items': preferences,
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('喜好食材：'),
        Wrap(
          spacing: 8.0,
          alignment: WrapAlignment.center,
          children: _foodTypes.map((type) {
            final isSelected = _selectedFoodTypes.contains(type);
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFoodTypes.add(type);
                  } else {
                    _selectedFoodTypes.remove(type);
                  }
                });
              },
              selectedColor: Colors.green,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        const Text('季節：'),
        Wrap(
          spacing: 8.0,
          children: _seasons.map((season) {
            final isSelected = _selectedSeasons.contains(season);
            return ChoiceChip(
              label: Text(season),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedSeasons.add(season);
                  } else {
                    _selectedSeasons.remove(season);
                  }
                });
              },
              selectedColor: Colors.green,
            );
          }).toList(),
        ),
      ],
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
                title: '設置你的個人口味',
                currentStep: 4,
                totalSteps: 4,
                content: '選擇你的喜好食材和季節',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton('立即開始', _savePreferences),
            ],
          ),
        ),
      ),
    );
  }
}
