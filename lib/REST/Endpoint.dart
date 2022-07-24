import 'dart:convert';
import 'dart:io';
class Endpoint{
  String name;
  late String urlpattern;
  late Map<String,Function> _handlers;

  Endpoint({this.name="UnnamedEndpoint",String? urlpattern}){
    assert(urlpattern!=null,"URL pattern must be defined for ${this.name}");
    this.urlpattern = urlpattern!;   
    _handlers = {
      'GET':get,
      'POST':post,
      'DELETE':delete,
      'PUT':put,
      'PATCH':patch
    };
  }

  handleRequest(HttpRequest request) async {
    await _handlers[request.method.toUpperCase()]!(request);
  }

  Future get(HttpRequest request) async {
    throw HttpException('Method not allowed'); 
  }

  Future post(HttpRequest request) async {
    throw HttpException('Method not allowed'); 
  }

  Future delete(HttpRequest request) async {
    throw HttpException('Method not allowed'); 
  }

  Future put(HttpRequest request) async {
    throw HttpException('Method not allowed'); 
  }

  Future patch(HttpRequest request) async {
    throw HttpException('Method not allowed'); 
  }

  static sendObjectAsJson(HttpRequest request,Object o) async {
    await request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(o))
      ..close();
  }
}

