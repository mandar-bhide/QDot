import 'dart:convert';
import 'dart:io';
import 'package:liquid_engine/liquid_engine.dart';

class ServerUtils{
  static Future<String> renderTemplate(String filename,[Map<String,dynamic>? data]) async {
    final context = Context.create();
    context.variables = data!;
    final template = Template.parse(context,Source.fromString(await File('templates/'+filename).readAsString()));
    return await template.render(context);
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

  static redirect(HttpRequest request, String url) {
    final htmlText = '''<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">\n
        <title>Redirecting...</title>\n
        <h1>Redirecting...</h1>\n
        <p>You should be redirected automatically to target URL: <a href="{html.escape(location)}">{display_location}</a>. 
        If not click the link.''';
    request.response
      ..headers.set('Location', url)
      ..headers.contentType = ContentType.html
      ..write(htmlText)
      ..close();
  }

  static String htmlEscape(String s) {
    s.replaceAll('&',"&amp;");
    s.replaceAll('<',"&lt;");
    s.replaceAll('>',"&gt;");
    return s;
  }

}

/*

 */