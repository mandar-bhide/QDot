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

  static redirect(HttpRequest request, String path) async {
    
    Uri uri;
    if(_isPathOnServer(path)){
      uri = Uri(
        host:request.requestedUri.host,
        port:request.requestedUri.port,
        path:path
      );
    }else{
      uri = Uri.parse(path);
    }
    /*
    final htmlText = '''<!DOCTYPE HTML>\n
        <title>Redirecting...</title>\n
        <h1>Redirecting...</h1>\n
        <p>You should be redirected automatically to target URL: <a href="${()=>htmlEscape(uri.toString())}">${uri.toString()}</a>. 
        If not click the link.''';*/
    await request.response.redirect(uri,status:301);
  }

  static String htmlEscape(String s) {
    s.replaceAll('&',"&amp;");
    s.replaceAll('<',"&lt;");
    s.replaceAll('>',"&gt;");
    return s;
  }

  static _isPathOnServer(String path) => path.startsWith('/');

}

/*

 */