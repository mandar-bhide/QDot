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

  handleRequest(HttpRequest request,Map<String,dynamic> pathParams) async {
    await _handlers[request.method.toUpperCase()]!(request,pathParams);
  }

  Future get(HttpRequest request,Map<String,dynamic> pathParams) async {
    throw HttpException('Method not allowed'); 
  }

  Future post(HttpRequest request,Map<String,dynamic> pathParams) async {
    throw HttpException('Method not allowed'); 
  }

  Future delete(HttpRequest request,Map<String,dynamic> pathParams) async {
    throw HttpException('Method not allowed'); 
  }

  Future put(HttpRequest request,Map<String,dynamic> pathParams) async {
    throw HttpException('Method not allowed'); 
  }

  Future patch(HttpRequest request,Map<String,dynamic> pathParams) async {
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

