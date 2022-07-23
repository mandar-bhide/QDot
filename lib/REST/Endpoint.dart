import 'dart:html';

class Endpoint{
  String name;
  late List<String> methods;
  late String urlpattern;

  Endpoint({this.name="UnnamedEndpoint",List<String>? methods,String? urlpattern}){
    assert(methods!=null,"Allowed methods must be defined for ${this.name}");
    this.methods = methods!.map((e) => e.toUpperCase()).toList();
    assert(urlpattern!=null,"URL pattern must be defined for ${this.name}");
    this.urlpattern = urlpattern!;    
  }

  get(HttpRequest request) async {
    if(!methods.contains('GET')) throw Exception('Method not allowed'); 
  }

  post(HttpRequest request) async {
    if(!methods.contains('POST')) throw Exception('Method not allowed'); 
  }

  delete(HttpRequest request) async {
    if(!methods.contains('DELETE')) throw Exception('Method not allowed'); 
  }

  put(HttpRequest request) async {
    if(!methods.contains('PUT')) throw Exception('Method not allowed'); 
  }

  patch(HttpRequest request) async {
    if(!methods.contains('PATCH')) throw Exception('Method not allowed'); 
  }
}


