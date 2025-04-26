import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  List<String> selectedPreferences = [];
  final preferences = {
    'taste': ['辣', '甜', '酸', '清淡'],
    'diet': ['素食', '葷食', '低卡'],
    'ingredients': ['紅蘿蔔', '青瓜', '豆腐', '米酒'],
    'season': ['穀雨', '清明', '立夏'],
  };

  void _signup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('密碼不一致', style: TextStyle(fontSize: 16))),
      );
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text,
        'preferences': {
          'taste': selectedPreferences
              .where((p) => preferences['taste']!.contains(p))
              .toList(),
          'diet': selectedPreferences
              .where((p) => preferences['diet']!.contains(p))
              .toList(),
          'ingredients': selectedPreferences
              .where((p) => preferences['ingredients']!.contains(p))
              .toList(),
          'season': selectedPreferences
              .where((p) => preferences['season']!.contains(p))
              .toList(),
        },
        'created_at': FieldValue.serverTimestamp(),
      });
      Navigator.pushNamed(context, '/guide');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('註冊失敗：$e', style: TextStyle(fontSize: 16))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('註冊',
            style: TextStyle(fontSize: 24, color: Color(0xFF1976D2))),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '電郵',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '密碼',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(fontSize: 20),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: '確認密碼',
                  labelStyle: TextStyle(fontSize: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                style: TextStyle(fontSize: 20),
                obscureText: true,
              ),
              SizedBox(height: 24),
              Text('選擇口味偏好',
                  style: TextStyle(fontSize: 20, color: Color(0xFF1976D2))),
              ...preferences.entries.map((entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(entry.key.toUpperCase(),
                          style: TextStyle(fontSize: 18)),
                      Wrap(
                        spacing: 8,
                        children: entry.value.map((pref) {
                          final isSelected = selectedPreferences.contains(pref);
                          return ChoiceChip(
                            label: Text(pref,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : Color(0xFF1976D2))),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedPreferences.add(pref);
                                } else {
                                  selectedPreferences.remove(pref);
                                }
                              });
                            },
                            selectedColor: Color(0xFF1976D2),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF1976D2)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          );
                        }).toList(),
                      ),
                    ],
                  )),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1976D2),
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('下一步',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
