import 'package:flutter/material.dart';

class InstallationsScreen extends StatelessWidget {
  const InstallationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Installations")),
      body: const Center(
        child: Text("Installations Page", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}