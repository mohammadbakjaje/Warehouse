import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Add%20request/add_request_page.dart';
import 'package:warehouse/screens/Login/log_in_screen.dart';
import 'package:warehouse/screens/MainUser/repos/logout_server_mangment.dart';
import 'package:warehouse/screens/ShowLastRequest/show_last_request.dart';
import 'package:warehouse/screens/ShowPersonal/show_personal.dart';

class UserHome extends StatelessWidget {
  static String id = "UserHome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: MyColors.orangeBasic,
        title: const Text('القائمة الرئيسية',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
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
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // زر إضافة طلب (كرت كبير مميز)
              _AnimatedCard(
                color: MyColors.orangeBasic,
                icon: Icons.add_circle_outline,
                title: "إضافة طلب",
                big: true,
                onTap: () {
                  Navigator.of(context).pushNamed(AddRequestPage.id);
                },
              ),

              const SizedBox(height: 30),

              // باقي الكروت بشكل Grid 2x2
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _AnimatedCard(
                    color: Colors.white,
                    icon: Icons.assignment_turned_in,
                    title: "عرض العهدة\nالشخصية",
                    onTap: () {
                      Navigator.of(context).pushNamed(ShowPersonal.id);
                    },
                  ),
                  _AnimatedCard(
                    color: Colors.white,
                    icon: Icons.list_alt,
                    title: "عرض الطلبات\nالسابقة",
                    onTap: () {
                      Navigator.of(context).pushNamed(ShowLastRequest.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool big;

  const _AnimatedCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.onTap,
    this.big = false,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 150),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        borderRadius: BorderRadius.circular(20),
        splashColor: MyColors.orangeBasic.withOpacity(0.2),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: widget.color,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: widget.big ? 40 : 20,
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon,
                    size: widget.big ? 60 : 40,
                    color: widget.color == Colors.white
                        ? MyColors.orangeBasic
                        : Colors.white),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.big ? 22 : 16,
                    fontWeight: FontWeight.bold,
                    color: widget.color == Colors.white
                        ? Colors.black87
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
