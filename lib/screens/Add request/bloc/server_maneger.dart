import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';

class ApiService {
  static String baseUrl = '$BaseUrl/products';
  static String authToken =
      '4|bvKL6oWZIa8ybiHf7ezQfwssID97cG0VAR7Byj7Xb77819b1';

  // دالة لجلب المنتجات باستخدام GET مع معلمات في URL
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      print("$query mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm" +
          '$baseUrl?name=$query');
      // إرسال استعلام البحث عبر معلمات URL
      final response = await http.get(
        Uri.parse('$baseUrl?name=$query'),
        headers: {
          'Accept': 'application/json', // تحديد نوع المحتوى
          'Authorization': 'Bearer $authToken', // إضافة التوكن في الهيدر
        }, // إضافة استعلام البحث في URL
      );

      // طباعة استجابة الـ API
      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          List<dynamic> products = data['data']['products'];
          return products
              .map((product) => product as Map<String, dynamic>)
              .toList();
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> submitRequest({
    required String date,
    required int warehouseKeeperId,
    required List<Map<String, String>> items,
  }) async {
    final url = Uri.parse('http://10.65.0.119:80/api/MRequest');

    final requestBody = {
      'date': date,
      'warehouse_keeper_id': warehouseKeeperId,
      'items': items.map((item) {
        return {
          'product_id': int.parse(item['product_id']!),
          'quantity_requested': int.parse(item['quantity']!),
          'notes': item['note']!,
        };
      }).toList(),
    };

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(requestBody),
    );

    print("Submit Request Status: ${response.statusCode}");
    print("Submit Request Body: ${response.body}");

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('فشل في إرسال الطلب');
    }
  }
}
