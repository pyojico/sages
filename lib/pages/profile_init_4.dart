import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/top_nav_center.dart';
import 'profile_page.dart';
import 'profile_init_3.dart';

class ProfileInit4 extends StatefulWidget {
  final bool fromSignUp;

  const ProfileInit4({super.key, required this.fromSignUp});

  @override
  _ProfileInit4State createState() => _ProfileInit4State();
}

class _ProfileInit4State extends State<ProfileInit4> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _foodTypes = ['雞肉', '蔬果', '水果', '素食', '湯類'];
  final List<String> _seasons = ['春季', '夏季', '秋季', '冬季'];
  final List<String> _selectedFoodTypes = [];
  final List<String> _selectedSeasons = [];

  void _savePreferences() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('preferences')
          .doc('food')
          .set({
        'foodTypes': _selectedFoodTypes,
        'seasons': _selectedSeasons,
      });

      if (widget.fromSignUp) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 垂直置中
      crossAxisAlignment: CrossAxisAlignment.start, // 水平置中
      children: [
        const Text('喜好食材：'),
        Wrap(
          spacing: 8.0,
          alignment: WrapAlignment.center, // Wrap 內部內容也置中
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
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileInit3(fromSignUp: widget.fromSignUp)),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton('立即開始', _savePreferences),
              TextButton(
                onPressed: () => widget.fromSignUp
                    ? Navigator.pushReplacementNamed(context, '/home')
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage())),
                child: const Text('略過'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
