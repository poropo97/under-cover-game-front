import 'package:uuid/uuid.dart';
import 'role.dart';

/// One participant in the game.
class Player {
  Player({
    required this.name,
    required this.role,
    this.order = 0,
  }) : id = const Uuid().v4();

  final String id;          // stable identifier
  String name;              // editable name
  Role role;                // assigned at game start
  int order;                // speaking order (0 → not yet defined)
  bool alive = true;        // ejected players are set to false

  @override
  String toString() => '$name [$id] - ${role.label}';
}
    