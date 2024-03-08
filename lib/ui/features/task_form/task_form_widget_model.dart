import 'package:flutter/material.dart';
import 'package:todo_list_app/domain/data_provider/box_manager.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';

class TaskFormWidgetModel {
  int groupKey;
  var taskText = '';

  TaskFormWidgetModel({required this.groupKey});

  //Сохраняем текущий таск
  Future<void> saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    final task = Task(text: taskText, isDone: false);
    final taskBox = await BoxManager.instance.openTaskBox(groupKey);
    await taskBox.add(task);

    await BoxManager.instance.closeBox(taskBox);

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
