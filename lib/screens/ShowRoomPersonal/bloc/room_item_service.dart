import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/local_network.dart';

class RoomItemService {
  final String apiUrl =
      '$BaseUrl/custody/specific'; // رابط الـ API لجلب العناصر
  final String returnUrl = '$BaseUrl/custody-returns'; // رابط الـ API للإرجاع

  // دالة لتحميل العناصر من الـ API
  Future<Map<String, dynamic>> fetchRoomItems(int roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$roomId'), // جلب العناصر بناءً على الـ roomId
        headers: {
          'Accept': 'application/json', // تحديد نوع المحتوى
          'Authorization': 'Bearer ${CacheNetwork.getCacheData(key: 'token')}'
        },
      );
      print(response.body); // لعرض الـ response في الـ console
      if (response.statusCode < 300) {
        return jsonDecode(response.body); // تحويل الاستجابة إلى JSON
      } else {
        throw Exception("حدث خطأ أثناء الاتصال بالخادم");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  // دالة للإرجاع
  // دالة للإرجاع
  Future<Map<String, dynamic>> returnItem(Map<dynamic, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(returnUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json', // Ensure this header is set
          'Authorization': 'Bearer ${CacheNetwork.getCacheData(key: 'token')}',
        },
        body: jsonEncode(data), // إرسال البيانات كـ JSON
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode < 500) {
        return jsonDecode(response.body); // تحويل الاستجابة إلى JSON
      } else {
        throw Exception(
            "حدث خطأ أثناء الاتصال بالخادم: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in returnItem: $e");
      throw Exception("حدث خطأ أثناء الإرجاع");
    }
  }
}
