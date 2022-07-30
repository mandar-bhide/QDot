import 'dart:convert';
import 'dart:io';

import 'package:qdot/URIHandler.dart';

import '../REST/Endpoint.dart';
import '../ServerUtils.dart';

class QDotREST{
  String name = "QDotREST Server";
  Map<RegExp,Endpoint> endpoints = Map<RegExp,Endpoint>();
  InternetAddress _host = InternetAddress.anyIPv4;
  int _port = 8000;
  HttpServer? _server;

  QDotREST({host,port,List<Endpoint>? endpoints}){
    if(host!=null) _host = host;
    if(port!=null) _port = port;
    if(endpoints!=null){
      for(Endpoint e in endpoints){
        this.endpoints[URIHandler.generateRegex(e.urlpattern)] = e;
      }
    }
  }

  bindServer() async {
    if(_server==null)
      _server = await HttpServer.bind(_host, _port,shared:true);
  }

  Future<dynamic> run() async {
    await bindServer();
    ProcessSignal.sigint.watch().listen((event) {
      if(event==ProcessSignal.sigint) exit(0);
    });

    print("Running server on http://${_host.address}:$_port");

    if(this._server!=null){
      await for (HttpRequest request in this._server!) {
        await handleRequest(request);
      }
    }
  }

  handleRequest(HttpRequest request) async {
    try{
      final x = endpoints.keys.firstWhere((element) => element.hasMatch(request.requestedUri.path));
      await endpoints[x]!.handleRequest(request,URIHandler.parsePath(endpoints[x]!.urlpattern,request.requestedUri.path));        
      print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${request.uri.path} HTTP/${request.protocolVersion}' 200");
    }on HttpException catch(e){
      print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${request.uri.path} HTTP/${request.protocolVersion}' 500");
      await request.response
        ..statusCode = 500      
        ..headers.contentType = ContentType.json        
        ..write(jsonEncode({'message':e.message}))
        ..close();
      return;
    }on StateError {
      request.response
        ..statusCode = 500      
        ..headers.contentType = ContentType.json        
        ..write(jsonEncode({'message':"No endpoint named ${request.requestedUri.path}"}))
        ..close();
    }
    
  }
  
}