import 'dart:io';
import '../Utils/URIHandler.dart';

class QDotRoute{
  String path = "/";
  late RegExp pathRegex;
  List<String> methods = ['GET'];

  QDotRoute({required this.path}){
    this.pathRegex = URIHandler.generateRegex(path);
  }

  setMethods(List<String> methods) => this.methods = methods;
  
  Future call(HttpRequest request,Map<String,dynamic> params) async {
    request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write("Method ${request.method} is not allowed on $path")
        ..close();
    return 405;
  }
  
}