import 'package:flutter/material.dart';
import 'package:todo_list_app/domain/data_provider/box_manager.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';

class GroupFormWidgetModel {
  var groupName = '';

  //Сохраняем текущую группу
  Future<void> saveGroup(BuildContext context) async {
    if (groupName.isEmpty) return;

    final groupBox = await BoxManager.instance.openGroupBox();
    final group = Group(name: groupName);
    await groupBox.add(group);

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
    return false;
  }
}
