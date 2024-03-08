import 'package:hive/hive.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};

  BoxManager._();

  Future<Box<Group>> openGroupBox() async {
    return _openBox(1, 'groupBox', GroupAdapter());
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(2, makeTaskBoxName(groupKey), TaskAdapter());
  }

  //Создаем имя боксов для тасков
  String makeTaskBoxName(int groupKey) => 'taskBox$groupKey';

  Future<void> closeBox<T>(Box<T> box) async {
    //Если бокс закрыт, удаляем оттуда счетчик по имени бокса
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }

    //Если бокс пока открыт, отнимаем от счетчик 1
    var counter = _boxCounter[box.name] ?? 1;
    counter -= 1;
    _boxCounter[box.name] = counter - 1;

    //Счетчик равен 0, это означает что мы закрыли бокс
    //столько раз, сколько раз мы открыли
    //и закрываем бокс
    //а если больше 0, то не закрываем
    if (counter > 0) return;
    _boxCounter.remove(box.name);

    box.compact();
    await box.close();
  }

  Future<Box<T>> _openBox<T>(
    int typeId,
    String boxName,
    TypeAdapter<T> adapter,
  ) async {
    //Если бокс открыт, счетчику добавляется 1
    if (Hive.isBoxOpen(boxName)) {
      final counter = _boxCounter[boxName] ?? 1;
      _boxCounter[boxName] = counter + 1;
      return Hive.box(boxName);
    }

    //Если бокс был закрыт, кладем 1 по этому имени,
    //то есть считается как первое открытие
    //затем открываю сам бокс
    _boxCounter[boxName] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }

    return Hive.openBox<T>(boxName);
  }
}
