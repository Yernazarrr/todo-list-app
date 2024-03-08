import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/domain/data_provider/box_manager.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';
import 'package:todo_list_app/ui/features/tasks/tasks_widget.dart';
import 'package:todo_list_app/ui/navigation/main_navigation.dart';

class TasksWidgetModel extends ChangeNotifier {
  TasksWidgetConfiguration configuration;
  ValueListenable<Object>? _listenableBox;

  late final Future<Box<Task>> _taskBox;

  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  TasksWidgetModel({required this.configuration}) {
    _setup();
  }

  //Показываем форму для таска
  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.tasksForm,
      arguments: configuration.groupKey,
    );
  }

  //Настраиваем бокс тасков, считаем уже существующие таски
  Future<void> _setup() async {
    _taskBox = BoxManager.instance.openTaskBox(configuration.groupKey);

    await _readTasksFromHive();
    _listenableBox = (await _taskBox).listenable();
    _listenableBox?.addListener(_readTasksFromHive);
  }

  //Считаем таски с Hive
  Future<void> _readTasksFromHive() async {
    _tasks = (await _taskBox).values.toList();
    notifyListeners();
  }

  //Удаляем таск по индексу
  Future<void> deleteTask(int taskIndex) async {
    await (await _taskBox).deleteAt(taskIndex);
  }

  Future<void> toggleDone(int taskIndex) async {
    final task = (await _taskBox).getAt(taskIndex);
    task?.isDone = !task.isDone;
    await task?.save();
  }

  //Удаляем подписку и закрываем бокс
  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readTasksFromHive);
    await BoxManager.instance.closeBox(await _taskBox);
    super.dispose();
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
