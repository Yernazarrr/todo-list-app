import 'package:flutter/material.dart';
import 'package:todo_list_app/ui/navigation/main_navigation.dart';
import 'package:todo_list_app/ui/theme/theme.dart';

class TodoListApp extends StatelessWidget {
  static final mainNavigation = MainNavigation();
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List App',
      theme: theme,
      routes: mainNavigation.routes,
      initialRoute: mainNavigation.initialRoute,
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
