import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_cubit.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_manger.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_model.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_states.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Notes/Bloc/OrderDetailsModel.dart';

class NotificationsPage extends StatelessWidget {
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
        body: BlocProvider(
          create: (context) =>
              NotificationCubit(NotificationService())..fetchNotifications(),
          child: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoading) {
                return Center(
                    child:
                        CircularProgressIndicator(color: MyColors.orangeBasic));
              } else if (state is NotificationError) {
                return Center(child: Text(state.message));
              } else if (state is NotificationLoaded) {
                final notifications = state.notifications;
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationCard(
                        context, notifications[index]);
                  },
                );
              } else {
                return _buildEmptyState();
              }
            },
          ),
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
    final bool isAccepted;
    if (notif.title == "تمت الموافقة على طلبك") {
      isAccepted = true;
    } else {
      isAccepted = false;
    }

    // تنسيق التاريخ
    String formattedDate = _formatDate(notif.createdAt);

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
                    "${notif.title} رقم ${notif.id}",
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
                  formattedDate, // استخدام التاريخ المُنسق هنا
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
                    _showOrderDetails(
                        context, notif.relatedId); // تمرير relatedId
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

  // دالة لتنسيق التاريخ
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      // تنسيق التاريخ ليعرض اليوم/الشهر/السنة والساعة:الدقيقة
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      return "تاريخ غير صالح"; // في حالة حدوث خطأ في تنسيق التاريخ
    }
  }

  // دالة لعرض تفاصيل الطلب داخل الـ Dialog
  void _showOrderDetails(BuildContext context, int relatedId) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<OrderDetailsModel?>(
              future: NotificationService()
                  .fetchOrderDetails(relatedId), // استدعاء API
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("حدث خطأ أثناء جلب تفاصيل الطلب"));
                } else if (snapshot.hasData) {
                  final orderDetails = snapshot.data!;
                  return SingleChildScrollView(
                    // يسمح بالتمرير عند الحاجة
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // العنوان
                        Text(
                          "تفاصيل الطلب",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign:
                              TextAlign.center, // محاذاة العنوان في المنتصف
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        // حالة الطلب
                        Text(
                          "حالة الطلب: ${orderDetails.status}",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.right, // محاذاة النص لليمين
                        ),
                        SizedBox(height: 16),
                        // كلمة المنتجات
                        Text(
                          "المنتجات:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right, // محاذاة النص لليمين
                        ),
                        SizedBox(height: 8),
                        // قائمة المنتجات
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: orderDetails.items.length,
                          itemBuilder: (context, index) {
                            final item = orderDetails.items[index];
                            return ListTile(
                              title: Text(item.productName),
                              subtitle: Text(
                                  "الكمية المطلوبة: ${item.quantityRequested} | الكمية المعتمدة: ${item.quantityApproved}"),
                            );
                          },
                        ),
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
                            child: Text("إغلاق",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text("لا توجد بيانات"));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
