import 'package:flutter/material.dart';

import '../../services/task_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/glass_card.dart';

class TaskRegisterPage extends StatefulWidget {
  const TaskRegisterPage({super.key});

  @override
  State<TaskRegisterPage> createState() => _TaskRegisterPageState();
}

class _TaskRegisterPageState extends State<TaskRegisterPage> {

  // ================= CONTROLLERS =================
  final TextEditingController taskIdController = TextEditingController();
  final TextEditingController stationController = TextEditingController();
  final TextEditingController zoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // ================= DROPDOWNS =================
  String taskType = "Maintenance";
  String priority = "Medium";
  String engineer = "Rahul";

  bool isLoading = false;

  // ================= REGISTER TASK =================
  Future<void> registerTask() async {

    setState(() {
      isLoading = true;
    });

    try {

      final response = await TaskService.registerTask(
        taskId: taskIdController.text.trim(),
        stationName: stationController.text.trim(),
        zoneName: zoneController.text.trim(),
        taskType: taskType,
        description: descriptionController.text.trim(),
        priority: priority,
        engineer: engineer,
      );

      if (response["success"] == true) {

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Task Registered")),
          );
        }

        // ================= CLEAR =================
        taskIdController.clear();
        stationController.clear();
        zoneController.clear();
        descriptionController.clear();

        setState(() {
          taskType = "Maintenance";
          priority = "Medium";
          engineer = "Rahul";
        });

      } else {

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration Failed")),
          );
        }
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Task Register"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: Stack(
        children: [

          // ================= BACKGROUND =================
          Positioned.fill(
            child: Image.asset(
              'assets/train.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),

          // ================= BODY =================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),

                child: GlassCard(
                  width: 700,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      // ================= TITLE =================
                      const Text(
                        "Register New Task",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Railway Task Management System",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= ROW 1 =================
                      Row(
                        children: [

                          Expanded(
                            child: CustomTextField(
                              hint: "Task ID",
                              controller: taskIdController,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: CustomTextField(
                              hint: "Station Name",
                              controller: stationController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ================= ROW 2 =================
                      Row(
                        children: [

                          Expanded(
                            child: CustomTextField(
                              hint: "Zone Name",
                              controller: zoneController,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: taskType,
                              dropdownColor: Colors.black,
                              style: const TextStyle(color: Colors.white),

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.08),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              items: const [
                                "Maintenance",
                                "Inspection",
                                "Repair",
                                "Installation",
                                "Emergency",
                              ]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),

                              onChanged: (value) {
                                setState(() {
                                  taskType = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ================= DESCRIPTION =================
                      CustomTextField(
                        hint: "Task Description",
                        controller: descriptionController,
                        maxLines: 5,
                      ),

                      const SizedBox(height: 18),

                      // ================= ROW 3 =================
                      Row(
                        children: [

                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: priority,
                              dropdownColor: Colors.black,
                              style: const TextStyle(color: Colors.white),

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.08),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              items: const [
                                "Low",
                                "Medium",
                                "High",
                                "Emergency",
                              ]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),

                              onChanged: (value) {
                                setState(() {
                                  priority = value!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: engineer,
                              dropdownColor: Colors.black,
                              style: const TextStyle(color: Colors.white),

                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.08),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                              ),

                              items: const [
                                "Rahul",
                                "Kumar",
                                "Arun",
                                "Vignesh",
                                "John",
                              ]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),

                              onChanged: (value) {
                                setState(() {
                                  engineer = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ================= BUTTONS =================
                      Row(
                        children: [

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              onPressed: isLoading ? null : registerTask,

                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Register Task",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[800],
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),

                              onPressed: () {
                                taskIdController.clear();
                                stationController.clear();
                                zoneController.clear();
                                descriptionController.clear();
                              },

                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}