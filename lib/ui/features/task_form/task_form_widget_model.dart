import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskText = '';

  TaskFormWidgetModel({required this.groupKey});

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final task = Task(text: taskText, isDone: false);
    final taskBox = await Hive.openBox<Task>('taskBox');
    await taskBox.add(task);

    final groupBox = await Hive.openBox<Group>('groupBox');
    final group = groupBox.get(groupKey);
    group?.addTask(taskBox, task);

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider(
      {super.key, required this.child, required this.model})
      : super(child: child);

  final Widget child;

  static TaskFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider oldWidget) {
    return false;
  }
}
