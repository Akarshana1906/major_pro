import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskReassignPage extends StatefulWidget {
  const TaskReassignPage({super.key});

  @override
  State<TaskReassignPage> createState() =>
      _TaskReassignPageState();
}

class _TaskReassignPageState
    extends State<TaskReassignPage> {

  List tasks = [];

  bool isLoading = true;

  // =========================================
  // IMPORTANT
  // =========================================
  // Use localhost for Chrome
  // Use your PC IP for Mobile
  //
  // CHROME:
  final String baseUrl =
      "http://localhost:3000";

  /*
  // MOBILE:
  final String baseUrl =
      "http://10.11.117.141:3000";
  */

  // =========================================
  // ENGINEERS
  // =========================================
  final List<String> engineers = [
    "Rahul",
    "Kumar",
    "Arun",
    "Vignesh",
    "John",
  ];

  // =========================================
  // DROPDOWN STATE
  // =========================================
  Map<int, String> selectedEngineers = {};

  @override
  void initState() {
    super.initState();

    fetchTasks();
  }

  // =========================================
  // FETCH TASKS
  // =========================================
  Future<void> fetchTasks() async {

    try {

      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse(
          "$baseUrl/tasks-register",
        ),
      );

      debugPrint(
        "STATUS CODE : ${response.statusCode}",
      );

      debugPrint(
        "BODY : ${response.body}",
      );

      if (response.statusCode == 200) {

        final data =
            jsonDecode(response.body);

        setState(() {

          tasks = data;

          selectedEngineers.clear();

          for (var task in tasks) {

            selectedEngineers[
                task["id"]] =
                task["assigned_engineer"]
                        ?.toString() ??
                    "Rahul";
          }

          isLoading = false;
        });
      }

      else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              "Server Error : ${response.statusCode}",
            ),
          ),
        );
      }
    }

    catch (e) {

      debugPrint(
        "FETCH ERROR : $e",
      );

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Connection Error : $e",
          ),
        ),
      );
    }
  }

  // =========================================
  // REASSIGN TASK
  // =========================================
  Future<void> reassignTask(
    int id,
    String engineer,
  ) async {

    try {

      final response = await http.put(

        Uri.parse(
          "$baseUrl/reassign-task-register/$id",
        ),

        headers: {
          "Content-Type":
              "application/json",
        },

        body: jsonEncode({
          "assigned_engineer":
              engineer,
        }),
      );

      debugPrint(
        "REASSIGN RESPONSE : ${response.body}",
      );

      final data =
          jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Task Reassigned Successfully",
            ),
          ),
        );

        fetchTasks();
      }

      else {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              data["message"] ??
                  "Reassign Failed",
            ),
          ),
        );
      }
    }

    catch (e) {

      debugPrint(
        "REASSIGN ERROR : $e",
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error : $e",
          ),
        ),
      );
    }
  }

  // =========================================
  // INFO ROW
  // =========================================
  Widget infoRow(
    String title,
    String value,
  ) {

    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 8,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          SizedBox(
            width: 120,

            child: Text(
              "$title :",

              style:
                  const TextStyle(
                color:
                    Colors.orange,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style:
                  const TextStyle(
                color:
                    Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      appBar: AppBar(

        title: const Text(
          "Task Reassign",
        ),

        backgroundColor:
            Colors.black,

        actions: [

          IconButton(
            onPressed: fetchTasks,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Colors.white,
              ),
            )

          : tasks.isEmpty

              ? const Center(
                  child: Text(
                    "No Tasks Found",

                    style: TextStyle(
                      color:
                          Colors.white,

                      fontSize: 18,
                    ),
                  ),
                )

              : ListView.builder(

                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  itemCount:
                      tasks.length,

                  itemBuilder:
                      (context, index) {

                    final task =
                        tasks[index];

                    final int id =
                        task["id"];

                    final String
                        selectedEngineer =
                        selectedEngineers[
                                id] ??
                            "Rahul";

                    return Container(

                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      decoration:
                          BoxDecoration(

                        color: Colors.white
                            .withOpacity(
                                0.08),

                        borderRadius:
                            BorderRadius
                                .circular(
                                    18),

                        border:
                            Border.all(
                          color:
                              Colors.white12,
                        ),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          // ================= HEADER =================
                          Row(
                            children: [

                              const Icon(
                                Icons.task,
                                color:
                                    Colors.orange,
                              ),

                              const SizedBox(
                                  width: 10),

                              Expanded(
                                child: Text(

                                  task["task_id"]
                                          ?.toString() ??
                                      "",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,

                                    fontSize:
                                        18,

                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 14),

                          // ================= DETAILS =================
                          infoRow(
                            "Station",
                            task["station_name"]
                                    ?.toString() ??
                                "",
                          ),

                          infoRow(
                            "Zone",
                            task["zone_name"]
                                    ?.toString() ??
                                "",
                          ),

                          infoRow(
                            "Task Type",
                            task["task_type"]
                                    ?.toString() ??
                                "",
                          ),

                          infoRow(
                            "Priority",
                            task["priority"]
                                    ?.toString() ??
                                "",
                          ),

                          infoRow(
                            "Status",
                            task["status"]
                                    ?.toString() ??
                                "",
                          ),

                          infoRow(
                            "Current Engineer",
                            task["assigned_engineer"]
                                    ?.toString() ??
                                "",
                          ),

                          const SizedBox(
                              height: 18),

                          // ================= DROPDOWN =================
                          DropdownButtonFormField<
                              String>(

                            value:
                                selectedEngineer,

                            dropdownColor:
                                Colors.black,

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                            ),

                            decoration:
                                InputDecoration(

                              filled: true,

                              fillColor:
                                  Colors.white
                                      .withOpacity(
                                          0.08),

                              border:
                                  OutlineInputBorder(

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            14),

                                borderSide:
                                    BorderSide.none,
                              ),
                            ),

                            items: engineers
                                .map(
                                  (engineer) =>
                                      DropdownMenuItem(

                                    value:
                                        engineer,

                                    child:
                                        Text(
                                      engineer,
                                    ),
                                  ),
                                )
                                .toList(),

                            onChanged:
                                (value) {

                              setState(() {

                                selectedEngineers[
                                        id] =
                                    value!;
                              });
                            },
                          ),

                          const SizedBox(
                              height: 16),

                          // ================= BUTTON =================
                          SizedBox(

                            width:
                                double.infinity,

                            child:
                                ElevatedButton(

                              style:
                                  ElevatedButton
                                      .styleFrom(

                                backgroundColor:
                                    Colors.orange,

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 16,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              14),
                                ),
                              ),

                              onPressed: () {

                                reassignTask(
                                  id,
                                  selectedEngineers[
                                          id] ??
                                      "Rahul",
                                );
                              },

                              child:
                                  const Text(

                                "Reassign Task",

                                style:
                                    TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}