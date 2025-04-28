import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/form_container_widget.dart';
import '../widgets/top_nav_center.dart';
import 'profile_init_3.dart';
import 'profile_init_0.dart';

class ProfileInit2 extends StatefulWidget {
  final bool fromSignUp;

  const ProfileInit2({super.key, required this.fromSignUp});

  @override
  _ProfileInit2State createState() => _ProfileInit2State();
}

class _ProfileInit2State extends State<ProfileInit2> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _familyNameController = TextEditingController();
  bool _hasFamilyId = false;
  String _existingFamilyName = '陳氏家族🏠'; // 模擬已存在嘅家庭名稱

  @override
  void initState() {
    super.initState();
    _checkFamilyId();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  void _checkFamilyId() async {
    final familyId = await _firestore.collection('families').limit(1).get();
    setState(() {
      _hasFamilyId = familyId.docs.isNotEmpty;
    });
  }

  void _joinFamily() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).set({
      'familyId': 'exampleFamilyId',
    }, SetOptions(merge: true));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileInit3(fromSignUp: widget.fromSignUp)));
  }

  void _createFamily() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final newFamily = await _firestore.collection('families').add({
      'name': _familyNameController.text.isEmpty
          ? '新家庭'
          : _familyNameController.text,
    });
    await _firestore.collection('users').doc(user.uid).set({
      'familyId': newFamily.id,
    }, SetOptions(merge: true));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileInit3(fromSignUp: widget.fromSignUp)));
  }

  Widget _buildSection() {
    if (_hasFamilyId) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center, // 垂直置中
        crossAxisAlignment: CrossAxisAlignment.center, // 水平置中
        children: [
          const Text('現有家庭：', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text(_existingFamilyName,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _joinFamily,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
            child: const Text('加入家庭'),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          const Text('建立新家庭：', style: TextStyle(fontSize: 16)),
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
          const Text('請建立你的家庭：', style: TextStyle(fontSize: 16)),
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
                title: '建立家庭計劃',
                currentStep: 2,
                totalSteps: 4,
                content: '共享家庭雪櫃庫存',
                onBackPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileInit0(fromSignUp: widget.fromSignUp)),
                ),
              ),
              Expanded(child: _buildSection()),
              _buildCustomButton('下一步', _createFamily),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileInit3(fromSignUp: widget.fromSignUp)),
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
