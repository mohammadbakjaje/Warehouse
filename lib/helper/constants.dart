import 'package:get_storage/get_storage.dart';
import 'local_network.dart';

final box = GetStorage();
String authToken = '3|TetVmvfohi7trLDdVJxlHGahKrQbwVRCwcyr5ywr162e660d';
final String ipv4 = "10.156.196.154:80";
String BaseUrl = 'http://$ipv4/api';
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
