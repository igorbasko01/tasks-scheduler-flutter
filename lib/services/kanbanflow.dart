import 'dart:convert';

import 'package:tasks_scheduler/models/kanbanflow/board.dart';
import 'package:tasks_scheduler/models/kanbanflow/task.dart';
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

  Future<List<KanbanFlowTask>> getTasks(String columnName, String swimlaneName) async {
    var response = await getBoard();
    if (response != null) {
      var column = response.columns.firstWhere((element) => element.name == columnName, orElse: () => const KanbanFlowColumn(id: '', name: ''));
      var swimlane = response.swimlanes.firstWhere((element) => element.name == swimlaneName, orElse: () => const KanbanFlowSwimlane(id: '', name: ''));
      if (column.id.isNotEmpty && swimlane.id.isNotEmpty) {
        var response = await networkClient.get('https://kanbanflow.com/api/v1/tasks?apiToken=$apiToken&columnId=${column.id}&swimlaneId=${swimlane.id}');
        if (response.statusCode == 200) {
          try {
            var decodedJson = jsonDecode(response.body);
            if (decodedJson is List) {
              var result = decodedJson.firstOrNull;
              if (result != null && result.containsKey('tasks')) {
                return KanbanFlowTask.fromJsonList(result['tasks']);
              }
            }
            return List.empty();
          } on FormatException {
            throw JsonParseException('Malformed JSON');
          }
        }
        throw HttpRequestException('Request failed with status: ${response.statusCode}', response.statusCode);
      }
    }
    return List.empty();
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