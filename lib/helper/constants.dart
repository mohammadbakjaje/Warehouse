import 'package:get_storage/get_storage.dart';
import 'local_network.dart';

final box = GetStorage();
final String ipv4 = "10.65.0.119:80";
String BaseUrl = 'http://$ipv4/api';
String removeChar(String input, String charToRemove) {
  String result = "";
  for (int i = 0; i < input.length; i++) {
    if (input[i] != charToRemove) {
      result += input[i];
    }
  }
  return result;
}
