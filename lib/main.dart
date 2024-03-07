import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/ui/features/group_form/group_form_widget.dart';
import 'package:todo_list_app/ui/features/groups/groups_widget.dart';
import 'package:todo_list_app/ui/features/tasks/tasks_widget.dart';
import 'package:todo_list_app/ui/theme/theme.dart';
import 'package:todo_list_app/ui/features/task_form/task_form_widget.dart';
import 'package:todo_list_app/ui/navigation/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List App',
      theme: theme,
      routes: {
        MainNavigationRouteNames.groups: (context) => const GroupsWidget(),
        MainNavigationRouteNames.groupsForm: (context) =>
            const GroupFormWidget(),
        MainNavigationRouteNames.tasks: (context) => const TasksWidget(),
        MainNavigationRouteNames.tasksForm: (context) => const TaskFormWidget(),
      },
      initialRoute: '/groups',
    );
  }
}
