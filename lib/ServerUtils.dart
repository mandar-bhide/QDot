import 'dart:convert';
import 'dart:io';

class ServerUtils{
  static Future<String> renderTemplate(String filename) async {
    File file = File.fromUri(Uri.file('templates/$filename'));
    return await file.readAsString();
  }

  static debugPrint(String string){
    print("[DEBUG] -- ${printDateTime()} : $string");
  }

  static printDateTime(){
    final dateTime = DateTime.now();
    final hour = dateTime.hour > 9 ? dateTime.hour.toString() : "0"+dateTime.hour.toString();
    final minute = dateTime.minute > 9 ? dateTime.minute.toString() : "0"+dateTime.minute.toString();
    final second = dateTime.second > 9 ? dateTime.second.toString() : "0"+dateTime.second.toString();
    return hour+":"+minute+":"+second;
  }

  static requestBodyMap(HttpRequest request) async {
    return jsonDecode(await utf8.decoder.bind(request).join());
  }

  static mapToJson(Map<String,dynamic> map){
    return jsonEncode(map);
  }

  static Future<Map<String,String>> getFormData(HttpRequest request) async {
    final queryParams = Uri(query:await utf8.decoder.bind(request).join()).queryParameters;
    return queryParams;
  }
}