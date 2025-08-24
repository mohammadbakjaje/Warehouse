import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

// موديل للإشعار
class NotificationModel {
  final int id;
  final String status; // "قبول" أو "رفض"
  final String message;
  final String date;
  final String material;
  final int quantity;

  NotificationModel({
    required this.id,
    required this.status,
    required this.message,
    required this.date,
    required this.material,
    required this.quantity,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      status: json['status'],
      message: json['message'],
      date: json['date'],
      material: json['material'],
      quantity: json['quantity'],
    );
  }
}

//الصفحة الاساسية
class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationModel>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture = fetchNotifications(); // استدعاء البيانات
  }

  // دالة تجيب بيانات (محاكاة - بدالها API/Firebase)
  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(Duration(seconds: 1)); // محاكاة تأخير

    return [
      NotificationModel(
        id: 101,
        status: "قبول",
        message:
            "وافق المدير على طلبك يرجى التوجه إلى أمين المستودع لاستلام المواد.",
        date: "2025-08-21",
        material: "قلم",
        quantity: 20,
      ),
      NotificationModel(
        id: 102,
        status: "رفض",
        message: "لم تتم الموافقة على طلبك، يرجى مراجعة الإدارة.",
        date: "2025-08-20",
        material: "برغي",
        quantity: 15,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "الإشعارات",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: MyColors.orangeBasic,
          centerTitle: true,
        ),
        body: FutureBuilder<List<NotificationModel>>(
          future: notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator(color: MyColors.orangeBasic));
            } else if (snapshot.hasError) {
              return Center(child: Text("حدث خطأ أثناء جلب البيانات"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            final notifications = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(context, notifications[index]);
              },
            );
          },
        ),
      ),
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

  Widget _buildNotificationCard(BuildContext context, NotificationModel notif) {
    final bool isAccepted = notif.status == "قبول";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Icon(
                  isAccepted ? Icons.check : Icons.close,
                  color: isAccepted ? Colors.green : Colors.red,
                  size: 28,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "تم ${notif.status} طلبك رقم ${notif.id}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // الرسالة
            Text(
              notif.message,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 14),
            // التاريخ + زر عرض الطلب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  notif.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.orangeBasic,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _showOrderDetails(context, notif);
                  },
                  child: Text(
                    "عرض الطلب",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context, NotificationModel notif) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        // 🔹 حتى الـ Dialog بالعربي
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("تفاصيل الطلب",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Divider(),
                SizedBox(height: 8),
                Text(" اسم المادة: ${notif.material}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(" الكمية: ${notif.quantity}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.orangeBasic,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "إغلاق",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
