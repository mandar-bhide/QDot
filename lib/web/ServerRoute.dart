import 'dart:io';

class ServerRoute{
  Function(HttpRequest) handler;
  List<String> methods = [];

  ServerRoute({required this.handler,List<String> methods=const ['GET']}){
    this.methods = methods.map((e) => e.toLowerCase()).toList();
  }

  setMethods(List<String> methods)=>this.methods = methods;
  addMethod(String method)=>this.methods.add(method);

  call(HttpRequest request) async {
    if(this.methods.contains(request.method.toLowerCase())){
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
}