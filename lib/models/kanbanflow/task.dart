import 'package:equatable/equatable.dart';

class KanbanFlowTask extends Equatable {
  final String id;
  final String name;
  final String color;
  final String columnId;
  final String swimlaneId;

  const KanbanFlowTask({required this.id, required this.name, required this.color, required this.columnId, required this.swimlaneId});

  static List<KanbanFlowTask> fromJsonList(List<dynamic> json) {
    return json.map((task) => KanbanFlowTask.fromJson(task)).where((task) => task != null).toList().cast<KanbanFlowTask>();
  }

  static KanbanFlowTask? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('_id') && json.containsKey('name') && json.containsKey('color') && json.containsKey('columnId') && json.containsKey('swimlaneId')) {
      return KanbanFlowTask(id: json['_id'], name: json['name'], color: json['color'], columnId: json['columnId'], swimlaneId: json['swimlaneId']);
    }
    return null;
  }

  @override
  List<Object> get props => [id, name, color, columnId, swimlaneId];
}