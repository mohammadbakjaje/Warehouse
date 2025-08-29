// warehouse_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';

class WarehouseService {
  final String apiUrl = '$BaseUrl/warehouses/index'; // API URL هنا

  Future<List<Map<String, dynamic>>> fetchWarehouses() async {
    print("start getting data");
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Accept': 'application/json', // تحديد نوع المحتوى
        'Authorization': 'Bearer $authToken', // وضع التوكن الخاص بك هنا
      });
      print(response.body);
      if (response.statusCode < 500) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          List<dynamic> warehousesJson = data['data'];
          return warehousesJson
              .map((json) => json as Map<String, dynamic>)
              .toList();
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
}
