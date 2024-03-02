import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list_app/domain/entity/group.dart';

class GroupFormWidgetModel {
  var groupName = '';
  void saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }

    final box = await Hive.openBox<Group>('groupBox');
    final group = Group(name: groupName);

    await box.add(group);

    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

class GroupFormWidgetModelProvider extends InheritedWidget {
  final GroupFormWidgetModel model;
  const GroupFormWidgetModelProvider({
    super.key,
    required this.child,
    required this.model,
  }) : super(child: child);

  final Widget child;

  static GroupFormWidgetModelProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupFormWidgetModelProvider>();
  }

  @override
  bool updateShouldNotify(GroupFormWidgetModelProvider oldWidget) {
    return true;
  }
}
