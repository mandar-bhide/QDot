import 'package:dart_server/REST/Endpoint.dart';

class QDotREST{
  String name = "QDotREST Server";
  List<Endpoint> endpoints = [];

  QDotREST();

  addEndpoint(Endpoint endpoint){
    endpoints.add(endpoint);
  }
}