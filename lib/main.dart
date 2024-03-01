import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list_app/features/group_form/group_form_widget.dart';
import 'package:todo_list_app/features/groups/groups_widget.dart';
import 'package:todo_list_app/theme/theme.dart';

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
        '/groups': (context) => const GroupsWidget(),
        '/groups/form': (context) => const GroupFormWidget(),
      },
      initialRoute: '/groups',
    );
  }
}
