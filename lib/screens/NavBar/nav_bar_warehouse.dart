import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/ProfilePage/profile-page.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MainUser/user_home.dart';

import '../Notes/notes_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // الصفحات يلي عندك
  final List<Widget> _pages = [
    UserHome(),
    ProfileScreen(),
    NotificationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: MyColors.orangeBasic,
        buttonBackgroundColor: MyColors.orangeBasic,
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.account_circle, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}

// ====== صفحات مؤقتة (بدلها بصفحاتك الحقيقية) ======
