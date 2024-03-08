import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_app/ui/features/groups/groups_widget_model.dart';

class GroupsWidget extends StatefulWidget {
  const GroupsWidget({super.key});

  @override
  State<GroupsWidget> createState() => _GroupsWidgetState();
}

class _GroupsWidgetState extends State<GroupsWidget> {
  final _model = GroupsWidgetModel();

  @override
  Widget build(BuildContext context) {
    return GroupsWidgetModelProvider(
      model: _model,
      child: const _GroupsWidgetBody(),
    );
  }

  @override
  void dispose() async {
    await _model.dispose();
    super.dispose();
  }
}

class _GroupsWidgetBody extends StatelessWidget {
  const _GroupsWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Группы'),
      ),
      body: const SafeArea(
        child: _GroupListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GroupsWidgetModelProvider.of(context)?.model.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget();

  @override
  Widget build(BuildContext context) {
    final groupsCount =
        GroupsWidgetModelProvider.of(context)?.model.groups.length ?? 0;

    return ListView.separated(
      itemCount: groupsCount,
      itemBuilder: (context, index) => _GroupListRowWidget(indexInList: index),
      separatorBuilder: (context, index) => const Divider(height: 1),
    );
  }
}

class _GroupListRowWidget extends StatelessWidget {
  final int indexInList;
  const _GroupListRowWidget({required this.indexInList});

  @override
  Widget build(BuildContext context) {
    final model = GroupsWidgetModelProvider.of(context)!.model;
    final group = model.groups[indexInList];

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => model.deleteGroup(indexInList),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Удалить',
          ),
        ],
      ),
      child: ListTile(
        title: Text(group.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => model.showTasks(context, indexInList),
      ),
    );
  }
}
