import 'dart:io';

import 'package:args/args.dart';
import 'package:qdot/REST/REST.dart';
import 'package:qdot/web/WebServer.dart';
import 'package:path/path.dart' as p;

export 'web/WebServer.dart';
export 'REST/REST.dart';
export './web/ServerRoute.dart';
export './REST/Endpoint.dart';
export 'ServerUtils.dart';

class QDot{
  WebServer? webServer;
  RESTServer? restServer;
  InternetAddress _host = InternetAddress.anyIPv4;
  int _port = 8000;
  HttpServer? _server;
  bool secure;

  QDot({this.webServer,this.restServer,List<String> args = const [], this.secure=false}){
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
    if(secure){
      SecurityContext context = SecurityContext.defaultContext;
      this._server = await HttpServer.bindSecure(_host,_port,context,shared:true);
    }
    this._server = await HttpServer.bind(_host, _port,shared:true);
    print("Running server on ${secure?'https':'http'}://${_host.address}:$_port");
    await for (HttpRequest request in this._server!) {
      try{
        if(_isWebRequest(request) && webServer!=null){
          await webServer!.handleRequest(request);
        }else if(_isRESTRequest(request) && restServer!=null){
          await restServer!.handleRequest(request);
        }
        
      }catch(e,s){
        print(e);
        print(s);
        continue;
      }
    }
  }

  bool _isWebRequest(HttpRequest request) => webServer!.filetypes.contains(p.extension(Uri.parse(request.requestedUri.toString()).path).replaceFirst('.','')) || webServer!.routes.keys.contains(Uri.parse(request.requestedUri.toString()).path);

  bool _isRESTRequest(HttpRequest request) => restServer!.endpoints[request.uri.path] != null;
}
