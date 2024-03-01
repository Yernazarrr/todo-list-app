import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class GroupsWidget extends StatelessWidget {
  const GroupsWidget({super.key});

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/form');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
      ),
      body: const SafeArea(
        child: _GroupListWidget(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GroupListWidget extends StatelessWidget {
  const _GroupListWidget();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 5,
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
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
          // SlidableAction(
          //   onPressed: (context) {},
          //   backgroundColor: const Color(0xFF21B7CA),
          //   foregroundColor: Colors.white,
          //   icon: Icons.share,
          //   label: 'Share',
          // ),
        ],
      ),
      child: const ListTile(
        title: Text('Some group'),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
