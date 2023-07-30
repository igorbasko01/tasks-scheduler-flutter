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
    var columns = json['columns'] as List;
    var swimlanes = json['swimlanes'] as List;
    var colors = json['colors'] as List;
    return KanbanFlowBoard(
      id: json['_id'],
      name: json['name'],
      columns: columns
          .map((column) => KanbanFlowColumn(id: column['uniqueId'], name: column['name']))
          .toList(),
      swimlanes: swimlanes
          .map((swimlane) =>
              KanbanFlowSwimlane(id: swimlane['uniqueId'], name: swimlane['name']))
          .toList(),
      colors: colors
          .map((color) => KanbanFlowColor(name: color['name'], value: color['value']))
          .toList(),
    );
  }

  @override
  List<Object> get props => [id, name, columns, swimlanes, colors];
}

class KanbanFlowColumn extends Equatable {
  final String id;
  final String name;

  const KanbanFlowColumn({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class KanbanFlowSwimlane extends Equatable {
  final String id;
  final String name;

  const KanbanFlowSwimlane({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class KanbanFlowColor extends Equatable {
  final String name;
  final String value;

  const KanbanFlowColor({required this.name, required this.value});

  @override
  List<Object> get props => [name, value];
}
