import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

class NotificationsPage extends StatelessWidget {
  final List<String> notifications = [
    "تم قبول طلبك ",
    "تم رفض طلبك ",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الإشعارات"),
        backgroundColor: MyColors.orangeBasic,
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.orangeAccent),
          SizedBox(height: 12),
          Text(
            "ليس لديك إشعارات",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ويدجت لعرض قائمة الإشعارات
  Widget _buildNotificationsList() {
    return ListView.separated(
      padding: EdgeInsets.all(18),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
          child: ListTile(
            leading: Icon(
              notifications[index].contains("رفض")
                  ? Icons.close_rounded
                  : Icons.check_circle,
              color: notifications[index].contains("رفض")
                  ? Colors.red
                  : Colors.green,
              size: 30,
            ),
            title: Text(
              notifications[index],
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
