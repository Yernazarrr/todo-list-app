import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/domain/data_provider/box_manager.dart';
import 'package:todo_list_app/domain/entity/group/group.dart';
import 'package:todo_list_app/ui/features/tasks/tasks_widget.dart';
import 'package:todo_list_app/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  late final Future<Box<Group>> _groupBox;
  var _groups = <Group>[];
  List<Group> get groups => _groups.toList();

  ValueListenable<Object>? _listenableBox;

  GroupsWidgetModel() {
    _setUp();
  }

  //Настраиваем боксы
  Future<void> _setUp() async {
    _groupBox = BoxManager.instance.openGroupBox();

    //Открываем уже существующие группы, если они есть
    await _readGroupsFromHive();

    _listenableBox = (await _groupBox).listenable();

    //Подписываемся на обновление группы
    _listenableBox?.addListener(_readGroupsFromHive);
  }

  //Считаем группы из Hive
  Future<void> _readGroupsFromHive() async {
    _groups = (await _groupBox).values.toList();
    notifyListeners();
  }

  //Удаляем группы
  Future<void> deleteGroup(int groupIndex) async {
    final groupBox = await _groupBox;

    final groupKey = (await _groupBox).keyAt(groupIndex) as int;

    //Берем имя бокса для таска
    final taskBoxName = BoxManager.instance.makeTaskBoxName(groupKey);

    //Сперва удаляем все таски c диска
    await Hive.deleteBoxFromDisk(taskBoxName);

    //Только потом удалям группу по индексу
    await groupBox.deleteAt(groupIndex);
  }

  //Показываем таскы
  Future<void> showTasks(BuildContext context, int groupIndex) async {
    final group = (await _groupBox).getAt(groupIndex);

    if (group != null) {
      final configuration = TasksWidgetConfiguration(
        groupKey: group.key as int,
        title: group.name,
      );

      if (!context.mounted) return;
      Navigator.of(context).pushNamed(
        MainNavigationRouteNames.tasks,
        arguments: configuration,
      );
    }
  }

  //Показываем формы заполнения
  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  //Удаляем подписку и закрываем бокс
  @override
  Future<void> dispose() async {
    _listenableBox?.removeListener(_readGroupsFromHive);
    await BoxManager.instance.closeBox(await _groupBox);

    super.dispose();
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
