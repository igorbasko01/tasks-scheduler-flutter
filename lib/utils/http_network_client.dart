import 'package:http/http.dart' as http;

import 'network_client.dart';

class HttpNetworkClient extends NetworkClient {

  @override
  Future<NetworkClientResponse> get(String url, {Map<String, String>? headers}) async {
    var response = await http.get(Uri.parse(url));
    return NetworkClientResponse(response.body, response.statusCode);
  }

  @override
  Future<NetworkClientResponse> delete(String url, {Map<String, String>? headers}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<NetworkClientResponse> post(String url, {Map<String, String>? headers, String? body}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<NetworkClientResponse> put(String url, {Map<String, String>? headers, String? body}) {
    // TODO: implement put
    throw UnimplementedError();
  }
}