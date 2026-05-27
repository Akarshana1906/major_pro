import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskOverallPage extends StatefulWidget {
  const TaskOverallPage({super.key});

  @override
  State<TaskOverallPage> createState() =>
      _TaskOverallPageState();
}

class _TaskOverallPageState
    extends State<TaskOverallPage> {

  List complaints = [];
  List filteredComplaints = [];

  bool isLoading = true;
  String error = "";

  final TextEditingController searchController =
      TextEditingController();

  String selectedStatus = "All";

  // ================= BASE URL =================
  final String baseUrl = "http://127.0.0.1:3000"; // CHANGE IF MOBILE

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  // =========================================
  // FETCH COMPLAINTS
  // =========================================
  Future<void> fetchComplaints() async {

    try {
      setState(() {
        isLoading = true;
        error = "";
      });

      final response = await http.get(
        Uri.parse('$baseUrl/complaints'),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        if (data is List) {

          setState(() {
            complaints = data;
            filteredComplaints = data;
            isLoading = false;
          });

        } else {
          setState(() {
            error = "Invalid API format";
            isLoading = false;
          });
        }

      } else {
        setState(() {
          error =
              "Server Error: ${response.statusCode}";
          isLoading = false;
        });
      }

    } catch (e) {
      setState(() {
        error = "Connection Error: $e";
        isLoading = false;
      });
    }
  }

  // =========================================
  // FILTER
  // =========================================
  void filterComplaints() {

    final query =
        searchController.text.toLowerCase();

    setState(() {
      filteredComplaints =
          complaints.where((c) {

        final id =
            c["complaint_id"]
                ?.toString()
                .toLowerCase() ??
            "";

        final station =
            c["station_name"]
                ?.toString()
                .toLowerCase() ??
            "";

        final engineer =
            c["assigned_engineer"]
                ?.toString()
                .toLowerCase() ??
            "";

        final status =
            c["status"]?.toString() ?? "";

        final matchesSearch =
            id.contains(query) ||
            station.contains(query) ||
            engineer.contains(query);

        final matchesStatus =
            selectedStatus == "All" ||
            status == selectedStatus;

        return matchesSearch &&
            matchesStatus;
      }).toList();
    });
  }

  // =========================================
  // COLORS
  // =========================================
  Color getStatusColor(String status) {

    switch (status) {
      case "Completed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color getPriorityColor(String priority) {

    switch (priority) {
      case "Emergency":
        return Colors.red;
      case "High":
        return Colors.deepOrange;
      case "Medium":
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Task Overview"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: fetchComplaints,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

          : error.isNotEmpty
              ? Center(
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )

              : Column(
                  children: [

                    // ================= SEARCH =================
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) => filterComplaints(),
                      ),
                    ),

                    // ================= LIST =================
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredComplaints.length,
                        itemBuilder: (context, index) {

                          final c = filteredComplaints[index];

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                            ),

                            child: Row(
                              children: [

                                Expanded(
                                  child: Text(
                                    c["complaint_id"] ?? "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    c["station_name"] ?? "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                Expanded(
                                  child: Text(
                                    c["assigned_engineer"] ?? "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: getPriorityColor(
                                      c["priority"] ?? "",
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    c["priority"] ?? "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                      c["status"] ?? "",
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    c["status"] ?? "",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}