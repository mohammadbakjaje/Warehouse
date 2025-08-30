import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_cubit.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_states.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_model.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    // استدعاء fetchNotifications عند بداية تحميل الصفحة
    context.read<NotificationCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text("الإشعارات"),
          backgroundColor: MyColors.orangeBasic,
          centerTitle: true,
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return Center(
                  child:
                      CircularProgressIndicator(color: MyColors.orangeBasic));
            } else if (state is NotificationError) {
              return Center(child: Text(state.message));
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return _buildNotificationCard(context, notifications[index]);
                },
              );
            }
            return Center(child: Text("لا توجد إشعارات"));
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
    final bool isAccepted = notif.type == "request_approved";

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
                    " إشعار رقم ${notif.id}",
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
            // التاريخ + زر عرض التفاصيل
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(notif.createdAt),
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
                    "عرض التفاصيل",
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
                // استبدل استخدام material بـ title
                Text("${notif.title}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                // استبدل استخدام quantity بـ message
                Text("${notif.message}", style: TextStyle(fontSize: 16)),
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
                    child: Text("إغلاق", style: TextStyle(color: Colors.white)),
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
