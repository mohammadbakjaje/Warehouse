import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';

class ProductService {
  final String baseUrl =
      "$BaseUrl/warehouses/show"; // Replace {{url}} with the actual API URL

  Future<Map<String, dynamic>> fetchProducts(int warehouseId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/$warehouseId'), headers: {
      'Accept': 'application/json', // تحديد نوع المحتوى
      'Authorization':
          'Bearer 1|XNFhlaQ12uyX4vFjkbNLJ9PWRo8iSuNmkTEv1ZIBcfa78a69',
    });
    print(response.body);
    if (response.statusCode < 500) {
      return jsonDecode(response.body); // Parse the response body
    } else {
      throw Exception('Failed to load product data');
    }
  }
}
