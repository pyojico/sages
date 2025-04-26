import 'package:flutter/material.dart';

class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  final _controller = PageController();
  final _pages = [
    {
      'icon': Icons.restaurant,
      'title': '發現節氣食譜',
      'description': '瀏覽穀雨美食，根據庫存推薦',
    },
    {
      'icon': Icons.camera_alt,
      'title': '掃描雪櫃食材',
      'description': '自動更新庫存，簡單方便',
    },
    {
      'icon': Icons.kitchen,
      'title': '管理庫存',
      'description': '雪櫃食物一目了然',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _pages[index]['icon'] as IconData,
                        size: 128,
                        color: Color(0xFF1976D2),
                      ),
                      SizedBox(height: 24),
                      Text(
                        _pages[index]['title'] as String,
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF1976D2)),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _pages[index]['description'] as String,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('開始使用',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
