abstract class NetworkClient {
  Future<NetworkClientResponse> get(String url, {Map<String, String>? headers});

  Future<NetworkClientResponse> post(String url,
      {Map<String, String>? headers, String body});

  Future<NetworkClientResponse> put(String url,
      {Map<String, String>? headers, String body});

  Future<NetworkClientResponse> delete(String url, {Map<String, String>? headers});
}

class NetworkClientResponse {
  final String body;
  final int statusCode;

  NetworkClientResponse(this.body, this.statusCode);
}