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
      return KanbanFlowBoard.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}