import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';
import 'package:todo_list_app/domain/entity/task/task.dart';
import 'package:todo_list_app/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  List<Group> get groups => _groups.toList();

  GroupsWidgetModel() {
    _setUp();
  }

  void _setUp() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final box = await Hive.openBox<Group>('groupBox');

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('taskBox');

    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }

  void deleteGroup(int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final box = await Hive.openBox<Group>('groupBox');
    await box.getAt(groupIndex)?.tasks?.deleteAllFromHive();

    await box.deleteAt(groupIndex);
  }

  void _readGroupsFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  void showTasks(BuildContext context, int groupIndex) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final box = await Hive.openBox<Group>('groupBox');
    final groupKey = box.keyAt(groupIndex);

    if (!context.mounted) return;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.tasks, arguments: groupKey);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(
          child: child,
          notifier: model,
        );

  final Widget child;

  static GroupsWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }
}
