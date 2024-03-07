import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';

class TasksWidgetModel extends ChangeNotifier {
  int groupKey;

  late final Future<Box<Group>> _groupBox;
  Group? _group;
  Group? get group => _group;

  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.groupKey}) {
    _setup();
  }

  void _setupListen() async {
    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(() => _readTasks());
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void deleteTask(int groupIndex) async {
    await _group?.tasks?.deleteFromHive(groupIndex);
    notifyListeners();
  }

  void toggleDone(int groupIndex) async {
    final task = group?.tasks?[groupIndex];

    final currentState = task?.isDone ?? false;
    task?.isDone = !currentState;
    task?.save();
    notifyListeners();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }

  void _loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    _groupBox = Hive.openBox<Group>('groupBox');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    Hive.openBox<Task>('taskBox');
    _loadGroup();
    _setupListen();
  }
}

class TasksWidgetModelProvider extends InheritedNotifier {
  final TasksWidgetModel model;
  const TasksWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
        );

  final Widget child;

  static TasksWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TasksWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(TasksWidgetModelProvider oldWidget) {
    return true;
  }
}
