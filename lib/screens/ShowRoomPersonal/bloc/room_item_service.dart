import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';

class RoomItemService {
  final String apiUrl =
      '$BaseUrl/custody/specific'; // URL الخاص بالـ API لجلب العناصر

  // دالة لتحميل العناصر من الـ API
  Future<Map<String, dynamic>> fetchRoomItems(int roomId) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$roomId'), // جلب العناصر بناءً على الـ roomId
        headers: {
          'Accept': 'application/json', // تحديد نوع المحتوى
          'Authorization': 'Bearer $authToken'
        },
      );
      print('$apiUrl/$roomId');
      print(response.body);
      if (response.statusCode < 300) {
        return jsonDecode(response.body); // تحويل الاستجابة إلى JSON
      } else {
        throw Exception("حدث خطأ أثناء الاتصال بالخادم");
      }
    } catch (e) {
      throw Exception("حدث خطأ أثناء جلب البيانات");
    }
  }
}
