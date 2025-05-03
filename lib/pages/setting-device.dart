import 'package:flutter/material.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/pages/profile_page.dart';
import '../widgets/top_nav_center.dart';
import 'profile_page.dart';

class Setting3 extends StatefulWidget {
  const Setting3({super.key});

  @override
  _Setting3State createState() => _Setting3State();
}

class _Setting3State extends State<Setting3> {
  bool _isLoading = true;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _simulateDeviceConnection();
  }

  void _simulateDeviceConnection() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isConnected = true;
      });
    }
  }

  Widget _buildSection() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('鏡頭已配對！', style: TextStyle(fontSize: 20)),
        SizedBox(height: 16),
        Icon(Icons.check_circle, color: Colors.green, size: 48),
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
                content: '鏡頭設備',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton(
                '完成',
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
