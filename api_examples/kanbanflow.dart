import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  test('kanbanflow get board', () async {
    var token = Platform.environment['KANBANFLOW_TOKEN'];
    var response = await http.get(Uri.parse('https://kanbanflow.com/api/v1/board?apiToken=$token'));
    print(response.body);
    expect(response.statusCode, 200);
  });

  test('kanbanflow get tasks of column In Progress in swimlane Personal', () async {
    var token = Platform.environment['KANBANFLOW_TOKEN'];
    var response = await http.get(Uri.parse('https://kanbanflow.com/api/v1/tasks?apiToken=$token&columnId=aezrgvwycNgp&swimlaneId=ahgNqFvK36HS'));
    print(response.body);
    expect(response.statusCode, 200);
  });

  test('kanbanflow get tasks of non existent column in swimlane Personal', () async {
    var token = Platform.environment['KANBANFLOW_TOKEN'];
    var response = await http.get(Uri.parse('https://kanbanflow.com/api/v1/tasks?apiToken=$token&columnId=nope&swimlaneId=ahgNqFvK36HS'));
    print(response.body);
    expect(response.statusCode, 403);
  });

  test('kanbanflow get tasks of non existent swimlane in column In Progress', () async {
    var token = Platform.environment['KANBANFLOW_TOKEN'];
    var response = await http.get(Uri.parse('https://kanbanflow.com/api/v1/tasks?apiToken=$token&columnId=aezrgvwycNgp&swimlaneId=nope'));
    print(response.body);
    expect(response.statusCode, 200);
  });
}