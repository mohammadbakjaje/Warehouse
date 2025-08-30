import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/screens/MovementOfMaterial/Movement/product-movement-model.dart';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<ProductMovementResponse> getProductMovements(int productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/product-movements/$productId'),
      headers: {
        'Accept': 'application/json',
        'Authorization':
            'Bearer 1|XNFhlaQ12uyX4vFjkbNLJ9PWRo8iSuNmkTEv1ZIBcfa78a69'
      },
    );
    print(response.body);
    if (response.statusCode < 500) {
      final jsonResponse = json.decode(response.body);
      return ProductMovementResponse.fromJson(jsonResponse);
    } else {
      throw Exception('فشل في جلب البيانات: ${response.statusCode}');
    }
  }
}
