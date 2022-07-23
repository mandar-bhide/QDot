import 'dart:collection';
import 'dart:io';
import 'package:mime/mime.dart';
import 'ServerRoute.dart';
import 'package:path/path.dart' as p;
import 'ServerUtils.dart';

class QDotServer{
  InternetAddress _host = InternetAddress.anyIPv4;
  int _port = 6969;
  HttpServer? _server;
  List<String> filetypes = [];
  HashMap<String,ServerRoute> routes = HashMap();

  DartServer(){
    routes['/'] = ServerRoute(handler:index,methods:['GET']);
  }

  Future<HttpServer?> bindServer({InternetAddress? host,int? port}) async {
    if(this._server==null){
      this._host = host==null ? this._host : host;
      this._port = port==null ? this._port : port;
      this._server = await HttpServer.bind(_host, _port,shared:true);
    }
    else
      print("Server already running on ${_host}:${_port}");

    return this._server;
  }

  addRoute({required String name,required ServerRoute route}){
    assert (!this.routes.containsKey(name),"Route $name already exists");
    routes[name] = route;
  }

  addFileType(String type)=>this.filetypes.add(type);

  index(HttpRequest request) async {
    File file = File.fromUri(Uri.file('dart_server/static/index.html'));
    final data = await file.readAsString();
    request.response
      ..headers.contentType = ContentType.html
      ..write(data)
      ..close();
  }

  _page_404(HttpRequest request) async {
    File file = File.fromUri(Uri.file('dart_server/static/404.html'));
    final data = await file.readAsString();
    request.response
      ..headers.contentType = ContentType.html
      ..write(data)
      ..close();
  }

  run() async {
    ProcessSignal.sigint.watch().listen((event) {
      if(event==ProcessSignal.sigint) exit(0);
    });

    print("Running server on http://${_host.address}:$_port");

    try{
      if(this._server!=null){
        await for (HttpRequest request in this._server!) {
          try{
            await _handleRequest(request);
          }catch(e){
            continue;
          }
        }
      }
    }catch(e){
      print(e);
    }
  }  

  _handleRequest(HttpRequest request) async {
    final endpoint = Uri.parse(request.requestedUri.toString()).path;
    int statusCode;
    if(this.filetypes.contains(p.extension(endpoint).replaceFirst('.',''))){
      try{
        final path = endpoint.replaceFirst('/', '${Directory.current.path.replaceAll('\\','/')}/');
        File file = File.fromUri(Uri.file(path));
        final mimeType = lookupMimeType(path)!.split('/');
        request.response
          ..headers.contentType = ContentType(mimeType[0],mimeType[1])
          ..statusCode = 200;     
        file.openRead().pipe(request.response);           
        statusCode = 200;
      }catch(e){
        request.response
          ..statusCode = 500
          ..close();
        statusCode = 500;
        throw Exception;
      }
      print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${endpoint} HTTP/${request.protocolVersion}' $statusCode");
      return;
    }
    if(routes.keys.contains(endpoint)){
      statusCode = await routes[endpoint]!.call(request);
    }else{                                    
      _page_404(request);
      statusCode = 404;
    }
    print("${_host.address} - - [${ServerUtils.printDateTime()}] '${request.method} ${endpoint} HTTP/${request.protocolVersion}' $statusCode");
  }
}