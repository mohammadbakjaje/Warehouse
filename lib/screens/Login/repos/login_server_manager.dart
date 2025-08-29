import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/local_network.dart';
import '../model/login_model.dart';

class LoginServerManager {
  Future<LoginModel> login(String phone, String password, String type) async {
    print("Starting login...");

    final Map<String, dynamic> requestBody = {
      "login": phone,
      "password": password,
      "type": type,
      "platform": "mobile",
    };

    try {
      final http.Response response = await http.post(
        Uri.parse('$BaseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // تحقق من success
        if (data['success'] == true) {
          // حفظ التوكن
          await CacheNetwork.insertToCache(
              key: "token", value: data['data']['access_token']);
          print("Token saved: ${data['data']['access_token']}");
          await CacheNetwork.insertIntToCache(
              key: "userId", value: data['data']['user']['id']);
          print("Id saved: ${data['data']['user']['id']}");

          return LoginModel.fromJson(data);
        } else {
          throw (data['message'] ?? 'Login failed');
        }
      } else {
        throw (data['message'] ?? 'Login failed');
      }
    } catch (e) {
      print("Login error: $e");
      rethrow;
    }
  }
}
