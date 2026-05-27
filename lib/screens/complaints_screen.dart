import 'package:flutter/material.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints")),
      body: const Center(
        child: Text("Complaints Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}