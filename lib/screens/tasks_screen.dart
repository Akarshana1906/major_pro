

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/engineer_model.dart';
import '../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  final String type;

  const TasksScreen({
    super.key,
    required this.type,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> tasks = [];
  bool isLoading = true;

  /// ✅ FIXED BASE URL
  static const String baseUrl = "http://127.0.0.1:3000";

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  /// =========================
  /// ✅ FETCH TASKS
  /// =========================
  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/tasks"),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to load tasks");
      }

      final data = jsonDecode(response.body);

      List<TaskModel> loadedTasks = [];

      for (var item in data) {
        final task = TaskModel.fromJson(item);

        if (widget.type == "all") {
          loadedTasks.add(task);
        } else if (task.type == widget.type) {
          loadedTasks.add(task);
        }
      }

      if (!mounted) return;

      setState(() {
        tasks = loadedTasks;
        isLoading = false;
      });
    } catch (e) {
      print("TASK FETCH ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load tasks"),
        ),
      );
    }
  }

  /// =========================
  /// ✅ REASSIGN TASK
  /// =========================
  Future<void> showReassignDialog(TaskModel task) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/engineers"),
      );

      final data = jsonDecode(response.body);

      List<EngineerModel> engineers = [];

      for (var item in data) {
        engineers.add(EngineerModel.fromJson(item));
      }

      String selectedEngineer = task.assignedTo;

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reassign Task'),
            content: StatefulBuilder(
              builder: (context, setDialogState) {
                return DropdownButton<String>(
                  value: selectedEngineer,
                  isExpanded: true,
                  items: engineers.map((engineer) {
                    return DropdownMenuItem(
                      value: engineer.name,
                      child: Text(engineer.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedEngineer = value!;
                    });
                  },
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await http.put(
                    Uri.parse(
                      "$baseUrl/reassign-task/${task.id}",
                    ),
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'assigned_to': selectedEngineer,
                    }),
                  );

                  Navigator.pop(context);
                  fetchTasks();
                },
                child: const Text('Reassign'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("REASSIGN ERROR: $e");
    }
  }

  /// =========================
  /// STATUS COLOR
  /// =========================
  Color getStatusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "in_progress":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type.toUpperCase()),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Text("No tasks found"),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(task.description),

                            const SizedBox(height: 14),

                            Chip(
                              backgroundColor:
                                  getStatusColor(task.status),
                              label: Text(
                                task.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(Icons.location_city),
                                const SizedBox(width: 8),
                                Text(task.depot),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(task.assignedTo),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    showReassignDialog(task);
                                  },
                                  icon: const Icon(Icons.swap_horiz),
                                  label: const Text("Reassign"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}