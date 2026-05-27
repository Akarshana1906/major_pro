import 'package:flutter/material.dart';

class OtherTasksScreen extends StatelessWidget {
  const OtherTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Other Tasks")),
      body: const Center(
        child: Text("Other Tasks Page"),
      ),
    );
  }
}