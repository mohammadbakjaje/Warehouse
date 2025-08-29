// services/custody_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:warehouse/helper/constants.dart';

class CustodyWKService {
  final String apiUrl = '$BaseUrl/custody/showAll';

  Future<List<Map<String, dynamic>>> fetchAllCustody() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          // Transform API data to match our app structure
          return _transformApiData(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load custody');
        }
      } else {
        throw Exception('Failed to load custody: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching custody: $e');
    }
  }

  // Transform API data to match our app structure
  List<Map<String, dynamic>> _transformApiData(List<dynamic> apiData) {
    return apiData.map<Map<String, dynamic>>((custody) {
      return {
        "id": custody['id'].toString(),
        "room": custody['room'] != null
            ? custody['room']['number'].toString()
            : "غير محدد",
        "owner": custody['user']['name'] ?? "غير معروف",
        "notes": custody['notes'] ?? "لا توجد ملاحظات",
        "items": custody['items'].map<Map<String, dynamic>>((item) {
          return {
            "name": item['product']['name'] ?? "غير معروف",
            "number": item['product']['code'] ?? "غير معروف",
            "quantity": item['quantity']?.toString() ?? "0",
            "memoId": item['exit_note_id']?.toString() ?? "غير معروف",
          };
        }).toList(),
      };
    }).toList();
  }
}
