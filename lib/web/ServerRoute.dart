import 'dart:io';

class ServerRoute{
  Function(HttpRequest) handler;
  List<String> methods = [];
  String path;

  ServerRoute({required this.path,required this.handler,List<String> methods=const ['GET']}){
    this.methods = methods.map((e) => e.toLowerCase()).toList();
  }

  setMethods(List<String> methods)=>this.methods = methods;
  addMethod(String method)=>this.methods.add(method);

  call(HttpRequest request) async {
    if(this.methods.contains(request.method.toLowerCase())){
      //final params = _parseUrl(request);
      try{
        final res = await handler(request);
        request.response
          ..headers.contentType = ContentType.html
          ..write(res)
          ..close();
        return 200;
      }catch(e){
        print(e);
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write("Server error")
          ..close();
        return 500;
      }
    }else{
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write("Method ${request.method} is not allowed.")
        ..close();
      return 405;
    }
  }

  Map<String,dynamic> _parseUrl(HttpRequest request){
    final pathSegments = path.split('/');
    final urlSegments = request.uri.pathSegments;
    
    if(pathSegments.length!=urlSegments.length) throw Exception('Bad Request');

    final ret = Map<String,dynamic>();
    for(int i=0;i<pathSegments.length;i++){
      if(pathSegments[i].startsWith('<')){
        final x = pathSegments[i].replaceAll('<','').replaceAll('>','').split(':');
        switch(x[0]){
          case 'num':            
            ret[x[1]] = num.parse(urlSegments[i]);
            break;
          default:
            ret[x[1]] = urlSegments[i].toString();
            break;
        }
      }
    }

    request.uri.queryParameters.forEach((key, value) => ret[key] = value);

    return ret;    
  }
}