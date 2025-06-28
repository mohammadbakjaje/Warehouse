import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/local_network.dart';

class LogoutServerManager {
  static Future<void> logout() async {
    print("Starting logout...");
    String? token = CacheNetwork.getCacheData(key: "token");

    if (token == null || token.isEmpty) {
      print("Token not found. Cancel logout.");
      throw ("Token not found");
    }

    try {
      final http.Response response = await http.post(
        Uri.parse('$BaseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer $token",
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print("Logout success");
        CacheNetwork.deleteCacheItem(key: "token");
      } else {
        throw (data['message'] ?? 'Logout failed');
      }
    } catch (e) {
      print("Logout error: $e");
      rethrow;
    }
  }
}
