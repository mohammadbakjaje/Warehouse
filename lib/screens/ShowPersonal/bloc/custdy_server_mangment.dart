import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/local_network.dart';

class CustodyService {
  final String apiUrl = '$BaseUrl/custody/allForUser'; // URL الخاص بالـ API

  // دالة لتحميل العهدة من الـ API
  Future<Map<String, dynamic>> fetchCustody() async {
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json', // تحديد نوع المحتوى
        'Authorization': 'Bearer ${CacheNetwork.getCacheData(key: 'token')}'
      });
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
