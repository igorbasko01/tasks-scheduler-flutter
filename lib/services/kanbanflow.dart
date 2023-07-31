import 'dart:convert';

import 'package:tasks_scheduler/models/kanbanflow/board.dart';
import 'package:tasks_scheduler/utils/network_client.dart';

class KanbanFlow {
  final NetworkClient networkClient;
  final String apiToken;

  KanbanFlow(this.networkClient, this.apiToken);

  Future<KanbanFlowBoard?> getBoard() async {
    var response = await networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken');
    if (response.statusCode == 200) {
      try {
        var decodedJson = jsonDecode(response.body);
        return KanbanFlowBoard.fromJson(decodedJson);
      } on FormatException {
        throw JsonParseException('Malformed JSON');
      }
    }
    throw HttpRequestException('Request failed with status: ${response.statusCode}', response.statusCode);
  }
}

class JsonParseException implements Exception {
  final String message;

  JsonParseException(this.message);
}

class HttpRequestException implements Exception {
  final String message;
  final int statusCode;

  HttpRequestException(this.message, this.statusCode);
}