import 'package:flutter/material.dart';

class GroupFormWidgetModel {}

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
