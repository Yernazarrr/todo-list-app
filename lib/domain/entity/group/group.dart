import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';

part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Task>? tasks;

  Group({required this.name});

  void addTask(Box<Task> taskBox, Task task) {
    tasks ??= HiveList(taskBox);
    tasks?.add(task);

    save();
  }
}
