import 'dart:io';
import 'package:args/args.dart';
import 'package:qdot/REST/REST.dart';
import 'package:qdot/web/WebServer.dart';
import 'package:path/path.dart' as p;
import 'Utils/ServerUtils.dart';
export 'web/WebServer.dart';
export 'REST/REST.dart';
export './web/ServerRoute.dart';
export './REST/Endpoint.dart';
export './Utils/ServerUtils.dart';

class QDot{
  WebServer? webServer;
  QDotREST? restServer;
  InternetAddress _host = InternetAddress.anyIPv4;
  int _port = 8000;
  HttpServer? _server;
  List<String> allowedOrigins = [];

  QDot({this.webServer,this.restServer,List<String> args = const [],this.allowedOrigins= const []}){
    ArgParser parser = ArgParser();
    parser.addOption('port',abbr:'p',defaultsTo:'8000');
    parser.addOption('host',abbr:'h',defaultsTo:'127.0.0.1');
    final clargs = parser.parse(args);
    _host = InternetAddress(clargs['host']);
    _port = int.parse(clargs['port']);
  }

  run() async {
    ProcessSignal.sigint.watch().listen((event) {
      if(event==ProcessSignal.sigint) exit(0);
    });

    this._server = await HttpServer.bind(_host, _port,shared:true);
    print("Running server on http://${_host.address}:$_port");

    await for (HttpRequest request in this._server!) {
      try{
        if(_isWebRequest(request) && webServer!=null){
          await webServer!.handleRequest(request);
        }else if(_isRESTRequest(request) && restServer!=null){
          await restServer!.handleRequest(request);
        }else{
          request.response
            ..statusCode = 410
            ..write("Invalid request. Please verify the URL.")
            ..close();
          print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${request.requestedUri.path} HTTP/${request.protocolVersion}' 400 [BAD REQUEST]");
        }   
        continue;            
      }catch(e,s){
        print(e);
        print(s);
        continue;
      }
    }
  }

  bool _isWebRequest(HttpRequest request) => 
    webServer!.filetypes.contains(p.extension(request.requestedUri.path).replaceFirst('.','')) || 
    webServer!.routes.keys.any((element) => element.hasMatch(request.requestedUri.path));

  bool _isRESTRequest(HttpRequest request) => 
    restServer!.endpoints.keys.any((element) => element.hasMatch(request.requestedUri.path));
}
