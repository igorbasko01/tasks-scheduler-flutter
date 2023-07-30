import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_scheduler/models/kanbanflow/board.dart';
import 'package:tasks_scheduler/services/kanbanflow.dart';
import 'package:tasks_scheduler/utils/network_client.dart';

@GenerateNiceMocks([MockSpec<NetworkClient>()])
import 'kanbanflow_test.mocks.dart';


void main() {
  group('KanbanFlow', () {
    test('getBoard returns a board with multiple columns and swimlanes', () async {
      var networkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      var expectedBoard = const KanbanFlowBoard(
        id: 'aaa',
        name: '2023',
        columns: [
          KanbanFlowColumn(id: 'col1', name: 'To-do'),
          KanbanFlowColumn(id: 'col2', name: 'In progress'),
          KanbanFlowColumn(id: 'col3', name: 'Done'),
        ],
        colors: [
          KanbanFlowColor(name: 'Yellow', value: 'yellow'),
          KanbanFlowColor(name: 'Green', value: 'green'),
          KanbanFlowColor(name: 'Blue', value: 'blue'),
          KanbanFlowColor(name: 'Red', value: 'red'),
          KanbanFlowColor(name: 'Orange', value: 'orange'),
          KanbanFlowColor(name: 'Purple', value: 'purple'),
          KanbanFlowColor(name: 'Magenta', value: 'magenta'),
          KanbanFlowColor(name: 'Cyan', value: 'cyan'),
        ],
        swimlanes: [
          KanbanFlowSwimlane(id: 'swim1', name: 'Morning Routine'),
          KanbanFlowSwimlane(id: 'swim2', name: 'Personal'),
          KanbanFlowSwimlane(id: 'swim3', name: 'Work'),
        ],
      );
      when(networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonResponse, 200);
      });
      var kanbanflow = KanbanFlow(networkClient, apiToken);
      var board = await kanbanflow.getBoard();
      expect(board, expectedBoard);
    });
  });
}