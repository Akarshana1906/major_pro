

import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool showMenu = false;

  void navigate(String route) {
    Navigator.pushNamed(context, "/$route");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.blueGrey.shade900,
      ),

      body: Center(
        child: MouseRegion(
          onEnter: (_) => setState(() => showMenu = true),
          onExit: (_) => setState(() => showMenu = false),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // ================= ADMIN BUTTON =================
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: const Text(
                  "ADMIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              // ================= DROPDOWN =================
              Positioned(
                top: 55,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: showMenu ? 1 : 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    transform: Matrix4.translationValues(
                        0, showMenu ? 0 : -10, 0),
                    child: showMenu
                        ? Container(
                            width: 240,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 18,
                                  color: Colors.black26,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                _item(Icons.assignment, "Tasks", "tasks"),
                                _item(Icons.engineering, "Engineers", "engineers"),
                                _item(Icons.build, "Installations", "installations"),
                                _item(Icons.report_problem, "Complaints", "complaints"),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(IconData icon, String title, String route) {
    return InkWell(
      onTap: () => navigate(route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.blueGrey.shade700),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}