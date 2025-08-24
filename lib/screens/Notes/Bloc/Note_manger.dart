// notification_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_model.dart';
import 'package:warehouse/screens/Notes/Bloc/OrderDetailsModel.dart';

class NotificationService {
  final String apiUrl = '$BaseUrl/allNotification-S'; // API URL هنا
  final String orderDetailsUrl = '$BaseUrl/M-Request/show'; // API URL هنا

  Future<List<NotificationModel>?> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json', // تحديد نوع المحتوى
        'Authorization': 'Bearer $authToken',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          List<dynamic> notificationsJson = data['data'];
          List<NotificationModel> notifications = notificationsJson.map((json) {
            return NotificationModel.fromJson(json);
          }).toList();
          return notifications;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('حدث خطأ أثناء جلب البيانات');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('حدث خطأ أثناء جلب البيانات');
    }
  }

  Future<OrderDetailsModel?> fetchOrderDetails(int relatedId) async {
    try {
      final response =
          await http.get(Uri.parse('$orderDetailsUrl/$relatedId'), headers: {
        'Accept': 'application/json', // تحديد نوع المحتوى
        'Authorization': 'Bearer $authToken'
      });
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return OrderDetailsModel.fromJson(data['data']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('حدث خطأ أثناء جلب تفاصيل الطلب');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('حدث خطأ أثناء جلب تفاصيل الطلب');
    }
  }
}
