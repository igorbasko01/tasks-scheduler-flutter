import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_scheduler/models/kanbanflow/board.dart';
import 'package:tasks_scheduler/models/kanbanflow/task.dart';
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

    test('getBoard returns null when handling malformed json', () async {
      var networkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}';
      when(networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonResponse, 200);
      });
      var kanbanflow = KanbanFlow(networkClient, apiToken);
      expect(() async => await kanbanflow.getBoard(), throwsA(isA<JsonParseException>()));
    });

    test('getBoard returns null when receiving a non 200 status code', () async {
      var networkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonResponse, 400);
      });
      var kanbanflow = KanbanFlow(networkClient, apiToken);
      expect(() async => await kanbanflow.getBoard(), throwsA(isA<HttpRequestException>()));
    });

    test('getBoard returns KanbanFlowBoard if missing one of the lists', () async {
      var networkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonResponse, 200);
      });
      var expectedBoard = const KanbanFlowBoard(
        id: 'aaa',
        name: '2023',
        columns: [
          KanbanFlowColumn(id: 'col1', name: 'To-do'),
          KanbanFlowColumn(id: 'col2', name: 'In progress'),
          KanbanFlowColumn(id: 'col3', name: 'Done'),
        ],
        colors: [],
        swimlanes: [
          KanbanFlowSwimlane(id: 'swim1', name: 'Morning Routine'),
          KanbanFlowSwimlane(id: 'swim2', name: 'Personal'),
          KanbanFlowSwimlane(id: 'swim3', name: 'Work'),
        ],
      );
      var kanbanflow = KanbanFlow(networkClient, apiToken);
      var board = await kanbanflow.getBoard();
      expect(board, expectedBoard);
    });

    test("getBoard ignores a column if json response doesn't contain all the fields in a column item", () async {
      var networkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonResponse, 200);
      });
      var expectedBoard = const KanbanFlowBoard(
        id: 'aaa',
        name: '2023',
        columns: [
          KanbanFlowColumn(id: 'col1', name: 'To-do'),
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
      var kanbanflow = KanbanFlow(networkClient, apiToken);
      var board = await kanbanflow.getBoard();
      expect(board, expectedBoard);
    });

    test('getBoard filter all columns that are invalid, returns empty columns list if all columns are invalid', () async {
      var networkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1"},{"uniqueId":"col2"},{"uniqueId":"col3"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(networkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonResponse, 200);
      });
      var expectedBoard = const KanbanFlowBoard(
        id: 'aaa',
        name: '2023',
        columns: [],
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
      var kanbanflow = KanbanFlow(networkClient, apiToken);
      var board = await kanbanflow.getBoard();
      expect(board, expectedBoard);
    });

    test('getTasks() returns tasks from a column named "In Progress" and swimlane named "Personal"', () async {
      var mockNetworkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonTasksResponse = '[{"columnId":"col2","columnName":"In progress","tasksLimited":false,"tasks":[{"_id":"task1","name":"task name 1","description":"","color":"blue","columnId":"col2","totalSecondsSpent":0,"totalSecondsEstimate":0,"swimlaneId":"swim2","subTasks":[{"name":"subtask1","finished":true},{"name":"subtask2","finished":false}]},{"_id":"task2","name":"task name 2","description":"task description 2","color":"blue","columnId":"col2","totalSecondsSpent":0,"totalSecondsEstimate":0,"swimlaneId":"swim2","subTasks":[{"name":"subtask1","finished":false},{"name":"subtask2","finished":false},{"name":"subtask3","finished":false},{"name":"subtask4","finished":false},{"name":"subtask5","finished":false},{"name":"subtask6","finished":false}]},{"_id":"task3","name":"task name 3","description":"","color":"green","columnId":"col2","totalSecondsSpent":0,"totalSecondsEstimate":0,"swimlaneId":"swim2","dates":[{"targetColumnId":"col2","status":"active","dateType":"dueDate","dueTimestamp":"2023-07-21T14:00:00Z","dueTimestampLocal":"2023-07-21T17:00:00+03:00"}]},{"_id":"task4","name":"task name 4","description":"","color":"purple","columnId":"col2","totalSecondsSpent":0,"totalSecondsEstimate":0,"swimlaneId":"swim2","subTasks":[{"name":"subtask1","finished":true},{"name":"subtask2","finished":true},{"name":"subtask3","finished":false},{"name":"subtask4","finished":false}]},{"_id":"task5","name":"task name 5","description":"","color":"purple","columnId":"col2","totalSecondsSpent":0,"totalSecondsEstimate":0,"swimlaneId":"swim2","subTasks":[{"name":"subtask1","finished":true},{"name":"subtask2","finished":true},{"name":"subtask3","finished":true},{"name":"subtask4","finished":false},{"name":"subtask5","finished":false}]}],"swimlaneId":"swim2","swimlaneName":"Personal"}]';
      var jsonBoardResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(mockNetworkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonBoardResponse, 200);
      });
      when(mockNetworkClient.get('https://kanbanflow.com/api/v1/tasks?apiToken=$apiToken&columnId=col2&swimlaneId=swim2')).thenAnswer((_) async {
        return NetworkClientResponse(jsonTasksResponse, 200);
      });
      var expectedTasks = [
        const KanbanFlowTask(id: 'task1', name: 'task name 1', color: 'blue', columnId: 'col2', swimlaneId: 'swim2'),
        const KanbanFlowTask(id: 'task2', name: 'task name 2', color: 'blue', columnId: 'col2', swimlaneId: 'swim2'),
        const KanbanFlowTask(id: 'task3', name: 'task name 3', color: 'green', columnId: 'col2', swimlaneId: 'swim2'),
        const KanbanFlowTask(id: 'task4', name: 'task name 4', color: 'purple', columnId: 'col2', swimlaneId: 'swim2'),
        const KanbanFlowTask(id: 'task5', name: 'task name 5', color: 'purple', columnId: 'col2', swimlaneId: 'swim2'),
      ];
      var kanbanflow = KanbanFlow(mockNetworkClient, apiToken);
      var tasks = await kanbanflow.getTasks('In progress', 'Personal');
      expect(tasks, expectedTasks);
    });

    test('getTasks() returns empty list if column doesnt exist', () async {
      var mockNetworkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonTasksResponse = '{"errors":[{"message":"No column was found with the given argument. Please check your arguments."}]}';
      var jsonBoardResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(mockNetworkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonBoardResponse, 200);
      });
      when(mockNetworkClient.get('https://kanbanflow.com/api/v1/tasks?apiToken=$apiToken&columnId=nope&swimlaneId=swim2')).thenAnswer((_) async {
        return NetworkClientResponse(jsonTasksResponse, 403);
      });
      var kanbanflow = KanbanFlow(mockNetworkClient, apiToken);
      var tasks = await kanbanflow.getTasks('nope', 'Personal');
      expect(tasks, List.empty());
    });

    test('getTasks() returns empty list if swimlane doesnt exist', () async {
      var mockNetworkClient = MockNetworkClient();
      var apiToken = 'KANBANFLOW_TOKEN';
      var jsonTasksResponse = '{"errors":[{"message":"Swimlane not found on the board"}]}';
      var jsonBoardResponse = '{"_id":"aaa","name":"2023","columns":[{"uniqueId":"col1","name":"To-do"},{"uniqueId":"col2","name":"In progress"},{"uniqueId":"col3","name":"Done"}],"colors":[{"name":"Yellow","value":"yellow"},{"name":"Green","value":"green"},{"name":"Blue","value":"blue"},{"name":"Red","value":"red"},{"name":"Orange","value":"orange"},{"name":"Purple","value":"purple"},{"name":"Magenta","value":"magenta"},{"name":"Cyan","value":"cyan"}],"swimlanes":[{"uniqueId":"swim1","name":"Morning Routine"},{"uniqueId":"swim2","name":"Personal"},{"uniqueId":"swim3","name":"Work"}]}';
      when(mockNetworkClient.get('https://kanbanflow.com/api/v1/board?apiToken=$apiToken')).thenAnswer((_) async {
        return NetworkClientResponse(jsonBoardResponse, 200);
      });
      when(mockNetworkClient.get('https://kanbanflow.com/api/v1/tasks?apiToken=$apiToken&columnId=col2&swimlaneId=nope')).thenAnswer((_) async {
        return NetworkClientResponse(jsonTasksResponse, 403);
      });
      var kanbanflow = KanbanFlow(mockNetworkClient, apiToken);
      var tasks = await kanbanflow.getTasks('In Progress', 'nope');
      expect(tasks, List.empty());
    });
  });
}