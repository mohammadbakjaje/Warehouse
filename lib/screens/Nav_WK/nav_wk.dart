import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/warehouses.dart';
import 'package:warehouse/screens/ShowPersonalForWK/show_personal_for_warehouse_kepper.dart';

class MainPageWK extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPageWK> {
  int _currentIndex = 0;

  // الصفحات يلي عندك
  final List<Widget> _pages = [
    ShowPersonalForWarehouseKepper(),
    WareHouses(),
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
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.all_inbox, size: 30, color: Colors.white), // حركة المواد
          Icon(Icons.badge_outlined,
              size: 30, color: Colors.white), // عرض العهد / المستخدمين
        ],
      ),
    );
  }
}
