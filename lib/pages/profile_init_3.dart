import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/top_nav_center.dart';
import 'profile_init_2.dart';
import 'profile_init_4.dart';

class ProfileInit3 extends StatefulWidget {
  final bool fromSignUp;

  const ProfileInit3({super.key, required this.fromSignUp});

  @override
  _ProfileInit3State createState() => _ProfileInit3State();
}

class _ProfileInit3State extends State<ProfileInit3> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _hasFamilyId = false;
  String _selectedDevice = 'ESP32-001'; // 模擬選擇嘅設備

  @override
  void initState() {
    super.initState();
    _checkFamilyId();
  }

  void _checkFamilyId() async {
    final familyId = await _firestore.collection('families').limit(2).get();
    setState(() {
      _hasFamilyId = familyId.docs.isNotEmpty;
    });
  }

  Widget _buildSection() {
    if (_hasFamilyId) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center, // 垂直置中
        crossAxisAlignment: CrossAxisAlignment.center, // 水平置中
        children: [
          Text('你的家庭成員已安裝鏡頭啦！', style: TextStyle(fontSize: 20)),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center, // 垂直置中
        crossAxisAlignment: CrossAxisAlignment.start, // 水平置中
        children: [
          const Text('請配對你的 ESP32 設備：', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: _selectedDevice,
            onChanged: (value) => setState(() => _selectedDevice = value!),
            items: ['ESP32-001', 'ESP32-002', 'ESP32-003']
                .map((device) =>
                    DropdownMenuItem(value: device, child: Text(device)))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Text('正在配對中...'),
          const CircularProgressIndicator(),
        ],
      );
    }
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
                title: '配對鏡頭設備',
                currentStep: 3,
                totalSteps: 4,
                content: '選擇鏡頭設備進行配對',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileInit2(fromSignUp: widget.fromSignUp)),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton(
                  '下一步',
                  () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileInit4(fromSignUp: widget.fromSignUp)),
                      )),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileInit4(fromSignUp: widget.fromSignUp)),
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
