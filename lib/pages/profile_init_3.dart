import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sages/constants/colors.dart';
import '../widgets/top_nav_center.dart';
import 'profile_init_2.dart';
import 'profile_init_4.dart';

class ProfileInit3 extends StatefulWidget {
  @override
  _ProfileInit3State createState() => _ProfileInit3State();
}

class _ProfileInit3State extends State<ProfileInit3> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _simulateDeviceConnection();
  }

  void _simulateDeviceConnection() async {
    await Future.delayed(Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isConnected = true;
      });
    }
  }

  Widget _buildSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('檢測到以下設備：', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        const Text(
          'ESP32-001',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Column(
            children: [
              Text('正在配對中...', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          )
        else
          const Column(
            children: [
              Text('成功連接！',
                  style: TextStyle(fontSize: 20, color: AppColors.green)),
              SizedBox(height: 16),
              Icon(Icons.check_circle, color: AppColors.green, size: 48),
            ],
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
                title: '配對鏡頭設備',
                currentStep: 3,
                totalSteps: 4,
                content: '確認鏡頭設備配對',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileInit2(),
                  ),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton(
                '完成設備配對',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileInit4(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileInit4(),
                  ),
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
