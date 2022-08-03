import 'dart:io';

class CORSPolicy{
  List<String>? allowOrigins;
  List<String>? allowMethods;
  List<String>? allowHeaders;
  int? maxAge;

  CORSPolicy({this.allowOrigins=const ['*'],this.allowMethods,this.allowHeaders,this.maxAge});

  factory CORSPolicy.allowAll() => CORSPolicy();
  factory CORSPolicy.allowOnlyMethods(List<String> methods) => CORSPolicy(allowMethods:methods);

  applyPolicy(HttpRequest request){
    request.response.headers.set('Access-Control-Allow-Origin',allowOrigins!);
    if(allowMethods!=null)
      request.response.headers.set('Access-Control-Request-Method',allowMethods!);
    if(allowHeaders!=null)
      request.response.headers.set('Access-Control-Request-Headers',allowHeaders!);
    if(maxAge!=null)
      request.response.headers.set('Access-Control-Max-Age',maxAge!);
    return request;
  }
}


class Method{
  static var get = 'GET';
  static var GET = 'GET';
  static var post = 'POST';
  static var POST = 'POST';
  static var delete = 'DELETE';
  static var DELETE = 'DELETE';
  static var put = 'PUT';
  static var PUT = 'PUT';
  static var patch = 'PATCH';
  static var PATCH = 'PATCH';
  static var all = '*';
}