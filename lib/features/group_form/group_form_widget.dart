import 'package:flutter/material.dart';

class GroupFormWidget extends StatelessWidget {
  const GroupFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New group'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: _GroupNameWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _GroupNameWidget extends StatelessWidget {
  const _GroupNameWidget();

  @override
  Widget build(BuildContext context) {
    return const TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Name of group',
      ),
    );
  }
}
