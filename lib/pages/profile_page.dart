import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/top_nav.dart';
import '../widgets/BottomNav.dart';
import 'setting-family.dart';
import 'setting-device.dart';
import 'setting-profile.dart';
import 'setting-prefer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _username = 'Loading...';
  String _avatar = '👨‍🦳';
  String _familyName = '未加入家庭';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // 讀取用戶資料
      final detailsDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('details')
          .get();
      // 讀取家庭資料
      final familyDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('info')
          .doc('family')
          .get();

      setState(() {
        if (detailsDoc.exists) {
          final data = detailsDoc.data()!;
          _username = data['name'] ?? 'User${user.uid.substring(0, 5)}';
          _avatar = data['avatar'] ?? '👨‍🦳';
        }
        if (familyDoc.exists) {
          final data = familyDoc.data()!;
          _familyName = data['name'] ?? '未知家庭';
        } else {
          _familyName = '未加入家庭';
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('載入用戶數據失敗：$e')));
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, "/email-login");
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('登出失敗：$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopNav(
              title: '個人檔案',
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          child: Text(
                            _avatar,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 50),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _familyName,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('更改個人資料'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Setting1(),
                          ),
                        );
                        _loadUserData(); // 返回時重新載入數據
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('加入家庭計劃'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Setting2(),
                          ),
                        );
                        _loadUserData(); // 返回時重新載入數據
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('設置鏡頭裝置'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Setting3(),
                          ),
                        );
                        _loadUserData(); // 返回時重新載入數據
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('更改口味偏好'),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Setting4(),
                          ),
                        );
                        _loadUserData(); // 返回時重新載入數據
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('通知'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        '登出',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppNavigationBar(),
    );
  }
}
