import 'dart:convert';
import 'dart:io';

import '../REST/Endpoint.dart';
import '../ServerUtils.dart';

class QDotREST{
  String name = "QDotREST Server";
  Map<String,Endpoint> endpoints = Map<String,Endpoint>();
  InternetAddress _host = InternetAddress.anyIPv4;
  int _port = 6969;
  HttpServer? _server;

  QDotREST({host,port}){
    if(host!=null) _host = host;
    if(port!=null) _port = port;
  }

  addEndpoint({required String url,required Endpoint endpoint}){
    endpoints[url] = endpoint;
  }

  _bindServer() async {
    if(_server==null)
      _server = await HttpServer.bind(_host, _port,shared:true);
  }

  run() async {
    await _bindServer();
    ProcessSignal.sigint.watch().listen((event) {
      if(event==ProcessSignal.sigint) exit(0);
    });

    print("Running server on http://${_host.address}:$_port");

    try{
      if(this._server!=null){
        await for (HttpRequest request in this._server!) {
          try{
            await endpoints[request.uri.path]!.handleRequest(request);
            print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${request.uri.path} HTTP/${request.protocolVersion}' 200");
          }on HttpException catch(e){
            print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${request.uri.path} HTTP/${request.protocolVersion}' 500");
            await request.response
              ..statusCode = 500              
              ..write(jsonEncode({'message':e.message}))
              ..close();
            continue;
          }
        }
      }
    }catch(e){
      print(e);
    }
  }
  
}