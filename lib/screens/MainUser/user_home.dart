import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Add%20request/add_request_page.dart';
import 'package:warehouse/screens/Login/log_in_screen.dart';
import 'package:warehouse/screens/Login/log_in_screen_for_warehouse_keeper.dart';
import 'package:warehouse/screens/MainUser/repos/logout_server_mangment.dart';
import 'package:warehouse/screens/ShowLastRequest/show_last_request.dart';
import 'package:warehouse/screens/ShowPersonal/show_personal.dart';

class UserHome extends StatelessWidget {
  static String id = "UserHome";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColors.orangeBasic,
        title: const Text('القائمة الرئيسية'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await LogoutServerManager.logout();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LogInScreen(),
                    ),
                  );
                } on Exception catch (e) {
                  print("logout failed $e");
                }
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 80,
            ),
            // زر إضافة طلب - كبير وفي النص
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.orangeBasic,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline,
                    size: 40, color: Colors.white),
                label: const Text(
                  'إضافة طلب',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AddRequestPage.id);
                },
              ),
            ),

            const SizedBox(height: 40),

            // صف الزرين تحت
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.assignment_turned_in,
                          color: Colors.white, size: 30),
                      label: const Text(
                        'عرض العهدة\nالشخصية',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(ShowPersonal.id);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.list_alt,
                          color: Colors.white, size: 30),
                      label: const Text(
                        'عرض الطلبات\nالسابقة',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(ShowLastRequest.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
