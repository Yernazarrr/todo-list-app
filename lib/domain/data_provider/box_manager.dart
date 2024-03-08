import 'package:hive/hive.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();

  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox(1, 'groupBox', GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(2, makeTaskBoxName(groupKey), TaskAdapter());
  }

  String makeTaskBoxName(int groupKey) => 'taskBox$groupKey';

  Future<void> closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(
    int typeId,
    String boxName,
    TypeAdapter<T> adapter,
  ) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }

    return Hive.openBox<T>(boxName);
  }
}
