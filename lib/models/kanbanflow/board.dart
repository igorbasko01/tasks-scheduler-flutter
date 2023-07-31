import 'package:equatable/equatable.dart';

class KanbanFlowBoard extends Equatable {
  final String id;
  final String name;
  final List<KanbanFlowColumn> columns;
  final List<KanbanFlowSwimlane> swimlanes;
  final List<KanbanFlowColor> colors;

  const KanbanFlowBoard(
      {required this.id,
      required this.name,
      required this.columns,
      required this.swimlanes,
      required this.colors});

  factory KanbanFlowBoard.fromJson(Map<String, dynamic> json) {
    var columns = json['columns'] as List? ?? [];
    var swimlanes = json['swimlanes'] as List? ?? [];
    var colors = json['colors'] as List? ?? [];
    return KanbanFlowBoard(
      id: json['_id'],
      name: json['name'],
      columns: columns
          .map((column) => KanbanFlowColumn.fromJson(column))
          .where((column) => column != null)
          .toList()
          .cast<KanbanFlowColumn>(),
      swimlanes: swimlanes
          .map((swimlane) => KanbanFlowSwimlane.fromJson(swimlane))
          .where((swimlane) => swimlane != null)
          .toList()
          .cast<KanbanFlowSwimlane>(),
      colors: colors
          .map((color) => KanbanFlowColor.fromJson(color))
          .where((color) => color != null)
          .toList()
          .cast<KanbanFlowColor>(),
    );
  }

  @override
  List<Object> get props => [id, name, columns, swimlanes, colors];
}

class KanbanFlowColumn extends Equatable {
  final String id;
  final String name;

  const KanbanFlowColumn({required this.id, required this.name});

  static KanbanFlowColumn? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('uniqueId') && json.containsKey('name')) {
      return KanbanFlowColumn(id: json['uniqueId'], name: json['name']);
    }
    return null;
  }

  @override
  List<Object> get props => [id, name];
}

class KanbanFlowSwimlane extends Equatable {
  final String id;
  final String name;

  const KanbanFlowSwimlane({required this.id, required this.name});

  static KanbanFlowSwimlane? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('uniqueId') && json.containsKey('name')) {
      return KanbanFlowSwimlane(id: json['uniqueId'], name: json['name']);
    }
    return null;
  }

  @override
  List<Object> get props => [id, name];
}

class KanbanFlowColor extends Equatable {
  final String name;
  final String value;

  const KanbanFlowColor({required this.name, required this.value});

  static KanbanFlowColor? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') && json.containsKey('value')) {
      return KanbanFlowColor(name: json['name'], value: json['value']);
    }
    return null;
  }

  @override
  List<Object> get props => [name, value];
}
