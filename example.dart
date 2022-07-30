import 'dart:io';
import 'package:qdot/main.dart';

class TestRoute extends QDotRoute{
  TestRoute() : super(path:"/test/<string:name>");
  @override
  Future call(HttpRequest request,Map<String,dynamic> params) async {
    final name = params['name'];
    final age = request.requestedUri.queryParameters['age'];
    return await ServerUtils.renderTemplate('test.html',{"name":name,"age":age,"redirect":"/"});
  }
}

class IndexRoute extends QDotRoute{
  IndexRoute() : super(path:"/");

  @override
  Future call(HttpRequest request,Map<String,dynamic> params) async {
    return await ServerUtils.renderTemplate('index.html',{"redirect":"/test/mandar","someFunction":"/someFunction"});
  }
}

class CustomEndpoint extends Endpoint{

  CustomEndpoint():super(urlpattern:'/endpoint/<string:uid>');
  
  @override
  get(HttpRequest request,Map<String,dynamic> pathParams){
    return Endpoint.sendObjectAsJson(request,{'uid':pathParams['uid']});
  }

  @override
  post(HttpRequest request,Map<String,dynamic> pathParams){
    return Endpoint.sendObjectAsJson(request,{'uid':pathParams['uid']});
  }
}

main(List<String> args) async {
  final server = QDot(
    webServer:WebServer(
      routes:[
        IndexRoute(),
        TestRoute()
      ]
    ),
    restServer:QDotREST(
      endpoints:[
        CustomEndpoint()
      ]
    )
  );

  await server.run();
}
