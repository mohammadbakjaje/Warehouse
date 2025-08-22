import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:warehouse/helper/constants.dart';

class RequestManager {
  static Future<List<Map<String, String>>> fetchRequests() async {
    try {
      final response = await http.get(
        Uri.parse('$BaseUrl/material-requests/user/$id'),
        headers: {
          'Accept': 'application/json', // تحديد نوع المحتوى
          'Authorization': 'Bearer $authToken', // إضافة التوكن في الهيدر
        },
      ); // إضافة استعلام البحث في URL);
      print(response.body);
      print("$BaseUrl/material-requests/user/$id");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          List<Map<String, String>> requests = [];
          for (var item in data['data']) {
            requests.add({
              'id': item['id'].toString(),
              'date': item['date'],
              'status': item['status'],
            });
          }
          return requests;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
