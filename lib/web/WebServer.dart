import 'dart:collection';
import 'dart:io';
import 'package:mime/mime.dart';
import '../Utils/URIHandler.dart';
import '../Utils/ServerUtils.dart';
import 'ServerRoute.dart';
import 'package:path/path.dart' as p;

class IndexRoute extends QDotRoute{

  IndexRoute(): super(path:"/");

  @override
  Future call(HttpRequest request,Map<String,dynamic> params) async {
    File file = File.fromUri(Uri.file('qdot/static/index.html'));
    final data = await file.readAsString();
    request.response
      ..headers.contentType = ContentType.html
      ..write(data)
      ..close();
  }
}

class WebServer{
  InternetAddress _host = InternetAddress.anyIPv4;
  int _port = 8000;
  HttpServer? _server;
  List<String> filetypes = [];
  HashMap<RegExp,QDotRoute> routes = HashMap();

  WebServer({host,port,List<QDotRoute>? routes,List<String> filetypes=const ['css','js','ico']}){
    this.routes[RegExp(r'^$')] = IndexRoute();
    if(host!=null) _host = host;
    if(port!=null) _port=port;
    if(routes!=null){
      for(QDotRoute r in routes){
        this.routes[URIHandler.generateRegex(r.path)] = r;
      }
    }
    this.filetypes = filetypes;
  }

  Future<HttpServer?> _bindServer() async {
    if(this._server==null){      
      this._server = await HttpServer.bind(_host, _port,shared:true);
    }
    else
      print("Server already running on ${_host}:${_port}");
    return this._server;
  }

  addFileType(String type)=>this.filetypes.add(type);

  Future<dynamic> run() async {
    await _bindServer();
    ProcessSignal.sigint.watch().listen((event) {
      if(event==ProcessSignal.sigint) exit(0);
    });
    print("Running server on http://${_host.address}:$_port");
    if(this._server!=null){
      await for (HttpRequest request in this._server!) {
        try{
          await handleRequest(request);
        }catch(e){
          continue;
        }
      }
    }
  }  

  Future handleRequest(HttpRequest request) async {
    final endpoint = Uri.parse(request.requestedUri.toString()).path;
    String statusCode = '';
    if(this.filetypes.contains(p.extension(endpoint).replaceFirst('.',''))){
      try{
        final path = endpoint.replaceFirst('/', '${Directory.current.path.replaceAll('\\','/')}/');
        File file = File.fromUri(Uri.file(path));
        final mimeType = lookupMimeType(path)!.split('/');
        request.response
          ..headers.contentType = ContentType(mimeType[0],mimeType[1])
          ..statusCode = 200;     
        file.openRead().pipe(request.response);           
        statusCode = '200 [OK]';
      }catch(e,s){
        print(e);
        print(s);
        request.response
          ..statusCode = 500
          ..close();
        statusCode = '500 [INTERNAL SERVER ERROR]';
      }
      print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${endpoint} HTTP/${request.protocolVersion}' $statusCode");
      return;
    }

    if(endpoint==""||endpoint=="/"){
      final res = await routes[RegExp(r'^/$')]!.call(request,URIHandler.parsePath(routes[RegExp(r'^/$')]!.path,endpoint));
      request.response
        ..headers.contentType = ContentType.html
        ..statusCode = 200
        ..write(res)
        ..close();
      statusCode = '200 [OK]';
      print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${endpoint} HTTP/${request.protocolVersion}' $statusCode");
      return;
    }

    try{
      final route = routes.keys.firstWhere((element) => element.hasMatch(endpoint));
      try{
        final res = await routes[route]!.call(request,URIHandler.parsePath(routes[route]!.path,endpoint));
        request.response
          ..statusCode = 200
          ..headers.contentType = ContentType.html
          ..write(res)
          ..close();  
        statusCode = '200 [OK]';
      }catch(e){
        request.response
          ..statusCode = 500
          ..write("Internal server error")
          ..close();
        statusCode = '500 [INTERNAL SERVER ERROR]';  
      }
    }catch(e){
      request.response
        ..statusCode = 400
        ..write("Malformed URL.")
        ..close();
      statusCode = '400 [BAD REQUEST]';
    }
    
    print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${endpoint} HTTP/${request.protocolVersion}' $statusCode");
  }
  
}