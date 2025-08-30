import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'local_network.dart';

final box = GetStorage();
String authToken = '3|TetVmvfohi7trLDdVJxlHGahKrQbwVRCwcyr5ywr162e660d';
final String ipv4 = "192.168.137.61:80";
String BaseUrl = 'https://ba86c0d15e29.ngrok-free.app/api';
int id = 6;
String removeChar(String input, String charToRemove) {
  String result = "";
  for (int i = 0; i < input.length; i++) {
    if (input[i] != charToRemove) {
      result += input[i];
    }
  }
  return result;
}

String formatDate(String date) {
// تحويل التاريخ باستخدام DateFormat
  DateTime parsedDate = DateTime.parse(date);
// تنسيق التاريخ ليعرض التاريخ والوقت بالدقائق
  return DateFormat('yyyy-MM-dd HH:mm').format(parsedDate);
}
