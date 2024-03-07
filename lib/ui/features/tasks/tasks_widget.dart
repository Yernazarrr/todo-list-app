import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_app/ui/features/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TasksWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TasksWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = _model;
    if (model != null) {
      return TasksWidgetModelProvider(
        model: model,
        child: const TasksWidgetBody(),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class TasksWidgetBody extends StatelessWidget {
  const TasksWidgetBody({super.key});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context)?.model;
    final groupTitle = model?.group?.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('$groupTitle'),
      ),
      body: const _TasksListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TasksListWidget extends StatelessWidget {
  const _TasksListWidget();

  @override
  Widget build(BuildContext context) {
    final tasksCount =
        TasksWidgetModelProvider.of(context)?.model.tasks.length ?? 0;

    return ListView.separated(
      itemCount: tasksCount,
      itemBuilder: (context, index) => _TasksListRowWidget(indexInList: index),
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }
}

class _TasksListRowWidget extends StatelessWidget {
  final int indexInList;
  const _TasksListRowWidget({required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = TasksWidgetModelProvider.of(context)!.model;
    final task = model.tasks[indexInList];

    final icon = task.isDone ? Icons.done : null;
    final style = task.isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : const TextStyle(decoration: TextDecoration.none);

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteTask(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          task.text,
          style: style,
        ),
        trailing: Icon(icon),
        onTap: () => model.toggleDone(indexInList),
      ),
    );
  }
}
