import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:warehouse/helper/constants.dart';

class ApiManager {
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$BaseUrl/v1/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print(response.body);
      print("$BaseUrl/v1/me");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          return {
            'success': true,
            'data': data['data'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'فشل في جلب البيانات',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'فشل في جلب البيانات: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      final response = await http.put(
        Uri.parse('$BaseUrl/v1/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      );

      print(response.body);
      print("$BaseUrl/v1/me");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          return {
            'success': true,
            'message': data['message'] ?? 'تم التحديث بنجاح',
            'data': data['data'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'فشل في تحديث البيانات',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'فشل في تحديث البيانات: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'حدث خطأ: $e',
      };
    }
  }
}
