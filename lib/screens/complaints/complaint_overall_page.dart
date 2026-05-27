import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplaintOverallPage extends StatefulWidget {
  const ComplaintOverallPage({super.key});

  @override
  State<ComplaintOverallPage> createState() =>
      _ComplaintOverallPageState();
}

class _ComplaintOverallPageState
    extends State<ComplaintOverallPage> {

  List complaints = [];

  List filteredComplaints = [];

  bool isLoading = true;

  final TextEditingController searchController =
      TextEditingController();

  String selectedStatus = "All";

  @override
  void initState() {
    super.initState();

    fetchComplaints();
  }

  // =========================================
  // FETCH COMPLAINTS
  // =========================================
  Future fetchComplaints() async {

    final url = Uri.parse(
      'http://localhost:3000/complaints',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {

      complaints =
          jsonDecode(response.body);

      filteredComplaints = complaints;

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================
  // SEARCH + FILTER
  // =========================================
  void filterComplaints() {

    String query =
        searchController.text.toLowerCase();

    setState(() {

      filteredComplaints =
          complaints.where((complaint) {

        final complaintId =
            complaint["complaint_id"]
                .toString()
                .toLowerCase();

        final station =
            complaint["station_name"]
                .toString()
                .toLowerCase();

        final engineer =
            complaint["assigned_engineer"]
                .toString()
                .toLowerCase();

        final status =
            complaint["status"]
                .toString();

        final matchesSearch =
            complaintId.contains(query) ||
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
  // STATUS COLOR
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

  // =========================================
  // PRIORITY COLOR
  // =========================================
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
      backgroundColor:
          const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text(
          "Complaint Overall Details",
        ),

        backgroundColor: const Color.fromARGB(255, 45, 45, 52),
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(
              children: [

                // =========================================
                // TOP FILTERS
                // =========================================

                Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Row(
                    children: [

                      // SEARCH

                      Expanded(
                        flex: 3,

                        child: TextField(
                          controller:
                              searchController,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),

                          decoration:
                              InputDecoration(

                            hintText:
                                "Search Complaint / Station / Engineer",

                            hintStyle:
                                const TextStyle(
                              color:
                                  Color.fromARGB(255, 244, 242, 242),
                            ),

                            filled: true,

                            fillColor:
                                Colors.white
                                    .withOpacity(
                                        0.08),

                            prefixIcon:
                                const Icon(
                              Icons.search,
                              color:
                                  Colors.white,
                            ),

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

                          onChanged: (value) {
                            filterComplaints();
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      // STATUS FILTER

                      Expanded(
                        flex: 1,

                        child:
                            DropdownButtonFormField<
                                String>(

                          value:
                              selectedStatus,

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

                          items: [

                            "All",

                            "Pending",

                            "In Progress",

                            "Completed",

                          ]
                              .map(
                                (e) =>
                                    DropdownMenuItem(
                                  value: e,

                                  child:
                                      Text(e),
                                ),
                              )
                              .toList(),

                          onChanged: (value) {

                            selectedStatus =
                                value!;

                            filterComplaints();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================
                // TABLE HEADER
                // =========================================

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.08),

                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),

                  child: const Row(
                    children: [

                      Expanded(
                        flex: 2,
                        child: Text(
                          "Complaint ID",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          "Station",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Text(
                          "Engineer",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          "Priority",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          "Status",

                          style: TextStyle(
                            color: Colors.white,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // =========================================
                // LIST
                // =========================================

                Expanded(
                  child: ListView.builder(

                    itemCount:
                        filteredComplaints.length,

                    itemBuilder:
                        (context, index) {

                      final complaint =
                          filteredComplaints[
                              index];

                      return Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),

                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withOpacity(
                                  0.05),

                          borderRadius:
                              BorderRadius
                                  .circular(
                                      14),

                          border: Border.all(
                            color:
                                Colors.white10,
                          ),
                        ),

                        child: Row(
                          children: [

                            Expanded(
                              flex: 2,

                              child: Text(
                                complaint[
                                        "complaint_id"] ??
                                    "",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,

                              child: Text(
                                complaint[
                                        "station_name"] ??
                                    "",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,

                              child: Text(
                                complaint[
                                            "assigned_engineer"] ??
                                        "",

                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      10,

                                  vertical: 6,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      getPriorityColor(
                                    complaint[
                                            "priority"] ??
                                        "",
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              10),
                                ),

                                child: Text(
                                  complaint[
                                          "priority"] ??
                                      "",

                                  textAlign:
                                      TextAlign
                                          .center,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors
                                            .white,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal:
                                      10,

                                  vertical: 6,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      getStatusColor(
                                    complaint[
                                            "status"] ??
                                        "",
                                  ),

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              10),
                                ),

                                child: Text(
                                  complaint[
                                          "status"] ??
                                      "",

                                  textAlign:
                                      TextAlign
                                          .center,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors
                                            .white,

                                    fontWeight:
                                        FontWeight
                                            .bold,

                                    fontSize: 12,
                                  ),
                                ),
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

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ComplaintOverallPage extends StatefulWidget {
//   const ComplaintOverallPage({super.key});

//   @override
//   State<ComplaintOverallPage> createState() =>
//       _ComplaintOverallPageState();
// }

// class _ComplaintOverallPageState
//     extends State<ComplaintOverallPage> {

//   List complaints = [];

//   List filteredComplaints = [];

//   bool isLoading = true;

//   final TextEditingController searchController =
//       TextEditingController();

//   String selectedStatus = "All";

//   final String baseUrl =
//       "http://localhost:3000";

//   @override
//   void initState() {
//     super.initState();

//     fetchComplaints();
//   }

//   // =========================================
//   // FETCH COMPLAINTS
//   // =========================================
//   Future fetchComplaints() async {

//     try {

//       final url = Uri.parse(
//         '$baseUrl/complaints',
//       );

//       final response =
//           await http.get(url);

//       if (response.statusCode == 200) {

//         complaints =
//             jsonDecode(response.body);

//         filteredComplaints =
//             complaints;

//         setState(() {
//           isLoading = false;
//         });

//       } else {

//         debugPrint(
//           "Failed : ${response.statusCode}",
//         );

//         setState(() {
//           isLoading = false;
//         });
//       }

//     } catch (e) {

//       debugPrint(e.toString());

//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // =========================================
//   // SEARCH + FILTER
//   // =========================================
//   void filterComplaints() {

//     String query =
//         searchController.text
//             .toLowerCase();

//     setState(() {

//       filteredComplaints =
//           complaints.where((complaint) {

//         final complaintId =
//             complaint["complaint_id"]
//                 .toString()
//                 .toLowerCase();

//         final station =
//             complaint["station_name"]
//                 .toString()
//                 .toLowerCase();

//         final engineer =
//             complaint["assigned_engineer"]
//                 .toString()
//                 .toLowerCase();

//         final status =
//             complaint["status"]
//                 .toString();

//         final matchesSearch =
//             complaintId.contains(query) ||
//             station.contains(query) ||
//             engineer.contains(query);

//         final matchesStatus =
//             selectedStatus == "All" ||
//             status == selectedStatus;

//         return matchesSearch &&
//             matchesStatus;

//       }).toList();
//     });
//   }

//   // =========================================
//   // STATUS COLOR
//   // =========================================
//   Color getStatusColor(String status) {

//     switch (status) {

//       case "Completed":
//         return Colors.green;

//       case "Pending":
//         return Colors.orange;

//       case "In Progress":
//         return Colors.blue;

//       default:
//         return Colors.grey;
//     }
//   }

//   // =========================================
//   // PRIORITY COLOR
//   // =========================================
//   Color getPriorityColor(
//     String priority,
//   ) {

//     switch (priority) {

//       case "Emergency":
//         return Colors.red;

//       case "High":
//         return Colors.deepOrange;

//       case "Medium":
//         return Colors.amber;

//       default:
//         return Colors.green;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor:
//           const Color(0xFF0F172A),

//       appBar: AppBar(
//         title: const Text(
//           "Complaint Overall Details",
//         ),

//         backgroundColor: Colors.black,
//       ),

//       body: isLoading

//           ? const Center(
//               child:
//                   CircularProgressIndicator(),
//             )

//           : filteredComplaints.isEmpty

//               ? const Center(
//                   child: Text(
//                     "No Complaints Found",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                 )

//               : Column(
//                   children: [

//                     // =========================================
//                     // SEARCH + FILTER
//                     // =========================================

//                     Padding(
//                       padding:
//                           const EdgeInsets
//                               .all(16),

//                       child: Row(
//                         children: [

//                           // SEARCH

//                           Expanded(
//                             flex: 3,

//                             child: TextField(
//                               controller:
//                                   searchController,

//                               style:
//                                   const TextStyle(
//                                 color:
//                                     Colors.white,
//                               ),

//                               decoration:
//                                   InputDecoration(

//                                 hintText:
//                                     "Search Complaint / Station / Engineer",

//                                 hintStyle:
//                                     const TextStyle(
//                                   color:
//                                       Colors.white54,
//                                 ),

//                                 filled: true,

//                                 fillColor:
//                                     Colors.white
//                                         .withOpacity(
//                                             0.08),

//                                 prefixIcon:
//                                     const Icon(
//                                   Icons.search,
//                                   color:
//                                       Colors.white,
//                                 ),

//                                 border:
//                                     OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                               14),

//                                   borderSide:
//                                       BorderSide
//                                           .none,
//                                 ),
//                               ),

//                               onChanged:
//                                   (value) {

//                                 filterComplaints();
//                               },
//                             ),
//                           ),

//                           const SizedBox(
//                               width: 16),

//                           // STATUS FILTER

//                           Expanded(
//                             flex: 1,

//                             child:
//                                 DropdownButtonFormField<
//                                     String>(

//                               value:
//                                   selectedStatus,

//                               dropdownColor:
//                                   Colors.black,

//                               style:
//                                   const TextStyle(
//                                 color:
//                                     Colors.white,
//                               ),

//                               decoration:
//                                   InputDecoration(

//                                 filled: true,

//                                 fillColor:
//                                     Colors.white
//                                         .withOpacity(
//                                             0.08),

//                                 border:
//                                     OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                               14),

//                                   borderSide:
//                                       BorderSide
//                                           .none,
//                                 ),
//                               ),

//                               items: [

//                                 "All",

//                                 "Pending",

//                                 "In Progress",

//                                 "Completed",

//                               ]
//                                   .map(
//                                     (e) =>
//                                         DropdownMenuItem(
//                                       value: e,

//                                       child:
//                                           Text(e),
//                                     ),
//                                   )
//                                   .toList(),

//                               onChanged:
//                                   (value) {

//                                 selectedStatus =
//                                     value!;

//                                 filterComplaints();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // =========================================
//                     // TABLE HEADER
//                     // =========================================

//                     Container(
//                       padding:
//                           const EdgeInsets
//                               .symmetric(
//                         vertical: 14,
//                         horizontal: 16,
//                       ),

//                       margin:
//                           const EdgeInsets
//                               .symmetric(
//                         horizontal: 16,
//                       ),

//                       decoration:
//                           BoxDecoration(
//                         color: Colors.white
//                             .withOpacity(
//                                 0.08),

//                         borderRadius:
//                             BorderRadius
//                                 .circular(
//                                     14),
//                       ),

//                       child: const Row(
//                         children: [

//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Complaint ID",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Station",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Engineer",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             child: Text(
//                               "Priority",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             child: Text(
//                               "Status",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(
//                         height: 10),

//                     // =========================================
//                     // LIST
//                     // =========================================

//                     Expanded(
//                       child:
//                           ListView.builder(

//                         itemCount:
//                             filteredComplaints
//                                 .length,

//                         itemBuilder:
//                             (context, index) {

//                           final complaint =
//                               filteredComplaints[
//                                   index];

//                           return Container(
//                             padding:
//                                 const EdgeInsets
//                                     .symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),

//                             margin:
//                                 const EdgeInsets
//                                     .symmetric(
//                               horizontal: 16,
//                               vertical: 6,
//                             ),

//                             decoration:
//                                 BoxDecoration(
//                               color: Colors
//                                   .white
//                                   .withOpacity(
//                                       0.05),

//                               borderRadius:
//                                   BorderRadius
//                                       .circular(
//                                           14),

//                               border:
//                                   Border.all(
//                                 color:
//                                     Colors
//                                         .white10,
//                               ),
//                             ),

//                             child: Row(
//                               children: [

//                                 Expanded(
//                                   flex: 2,

//                                   child: Text(
//                                     complaint[
//                                             "complaint_id"] ??
//                                         "",

//                                     style:
//                                         const TextStyle(
//                                       color:
//                                           Colors
//                                               .white,
//                                     ),
//                                   ),
//                                 ),

//                                 Expanded(
//                                   flex: 2,

//                                   child: Text(
//                                     complaint[
//                                             "station_name"] ??
//                                         "",

//                                     style:
//                                         const TextStyle(
//                                       color:
//                                           Colors
//                                               .white,
//                                     ),
//                                   ),
//                                 ),

//                                 Expanded(
//                                   flex: 2,

//                                   child: Text(
//                                     complaint[
//                                                 "assigned_engineer"] ??
//                                             "",

//                                     style:
//                                         const TextStyle(
//                                       color:
//                                           Colors
//                                               .white,
//                                     ),
//                                   ),
//                                 ),

//                                 Expanded(
//                                   child:
//                                       Container(
//                                     padding:
//                                         const EdgeInsets
//                                             .symmetric(
//                                       horizontal:
//                                           10,

//                                       vertical:
//                                           6,
//                                     ),

//                                     decoration:
//                                         BoxDecoration(
//                                       color:
//                                           getPriorityColor(
//                                         complaint[
//                                                 "priority"] ??
//                                             "",
//                                       ),

//                                       borderRadius:
//                                           BorderRadius
//                                               .circular(
//                                                   10),
//                                     ),

//                                     child: Text(
//                                       complaint[
//                                               "priority"] ??
//                                           "",

//                                       textAlign:
//                                           TextAlign
//                                               .center,

//                                       style:
//                                           const TextStyle(
//                                         color:
//                                             Colors
//                                                 .white,

//                                         fontWeight:
//                                             FontWeight
//                                                 .bold,

//                                         fontSize:
//                                             12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(
//                                     width: 10),

//                                 Expanded(
//                                   child:
//                                       Container(
//                                     padding:
//                                         const EdgeInsets
//                                             .symmetric(
//                                       horizontal:
//                                           10,

//                                       vertical:
//                                           6,
//                                     ),

//                                     decoration:
//                                         BoxDecoration(
//                                       color:
//                                           getStatusColor(
//                                         complaint[
//                                                 "status"] ??
//                                             "",
//                                       ),

//                                       borderRadius:
//                                           BorderRadius
//                                               .circular(
//                                                   10),
//                                     ),

//                                     child: Text(
//                                       complaint[
//                                               "status"] ??
//                                           "",

//                                       textAlign:
//                                           TextAlign
//                                               .center,

//                                       style:
//                                           const TextStyle(
//                                         color:
//                                             Colors
//                                                 .white,

//                                         fontWeight:
//                                             FontWeight
//                                                 .bold,

//                                         fontSize:
//                                             12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class TaskOverallPage extends StatefulWidget {
//   const TaskOverallPage({super.key});

//   @override
//   State<TaskOverallPage> createState() =>
//       _TaskOverallPageState();
// }

// class _TaskOverallPageState
//     extends State<TaskOverallPage> {

//   List tasks = [];

//   List filteredTasks = [];

//   bool isLoading = true;

//   final TextEditingController searchController =
//       TextEditingController();

//   String selectedStatus = "All";

//   final String baseUrl =
//       "http://localhost:3000";

//   @override
//   void initState() {
//     super.initState();

//     fetchTasks();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   // =========================================
//   // FETCH TASKS
//   // =========================================
//   Future fetchTasks() async {

//     try {

//       final url = Uri.parse(
//         '$baseUrl/tasks-register',
//       );

//       final response =
//           await http.get(url);

//       if (response.statusCode == 200) {

//         tasks =
//             jsonDecode(response.body);

//         filteredTasks =
//             List.from(tasks);

//         setState(() {
//           isLoading = false;
//         });

//       } else {

//         debugPrint(
//           "Failed : ${response.statusCode}",
//         );

//         setState(() {
//           isLoading = false;
//         });
//       }

//     } catch (e) {

//       debugPrint(e.toString());

//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // =========================================
//   // SEARCH + FILTER
//   // =========================================
//   void filterTasks() {

//     String query =
//         searchController.text
//             .toLowerCase();

//     setState(() {

//       filteredTasks =
//           tasks.where((task) {

//         final taskId =
//             task["task_id"]
//                 .toString()
//                 .toLowerCase();

//         final station =
//             task["station_name"]
//                 .toString()
//                 .toLowerCase();

//         final engineer =
//             task["assigned_engineer"]
//                 .toString()
//                 .toLowerCase();

//         final status =
//             task["status"]
//                 .toString();

//         final matchesSearch =
//             taskId.contains(query) ||
//             station.contains(query) ||
//             engineer.contains(query);

//         final matchesStatus =
//             selectedStatus == "All" ||
//             status == selectedStatus;

//         return matchesSearch &&
//             matchesStatus;

//       }).toList();
//     });
//   }

//   // =========================================
//   // STATUS COLOR
//   // =========================================
//   Color getStatusColor(String status) {

//     switch (status) {

//       case "Completed":
//         return Colors.green;

//       case "Pending":
//         return Colors.orange;

//       case "In Progress":
//         return Colors.blue;

//       default:
//         return Colors.grey;
//     }
//   }

//   // =========================================
//   // PRIORITY COLOR
//   // =========================================
//   Color getPriorityColor(
//     String priority,
//   ) {

//     switch (priority) {

//       case "Emergency":
//         return Colors.red;

//       case "High":
//         return Colors.deepOrange;

//       case "Medium":
//         return Colors.amber;

//       default:
//         return Colors.green;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor:
//           const Color(0xFF0F172A),

//       appBar: AppBar(
//         title: const Text(
//           "Task Overall Details",
//         ),

//         backgroundColor: Colors.black,
//       ),

//       body: isLoading

//           ? const Center(
//               child:
//                   CircularProgressIndicator(),
//             )

//           : filteredTasks.isEmpty

//               ? const Center(
//                   child: Text(
//                     "No Tasks Found",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                 )

//               : Column(
//                   children: [

//                     // =========================================
//                     // SEARCH + FILTER
//                     // =========================================

//                     Padding(
//                       padding:
//                           const EdgeInsets
//                               .all(16),

//                       child: Row(
//                         children: [

//                           // SEARCH

//                           Expanded(
//                             flex: 3,

//                             child: TextField(
//                               controller:
//                                   searchController,

//                               style:
//                                   const TextStyle(
//                                 color:
//                                     Colors.white,
//                               ),

//                               decoration:
//                                   InputDecoration(

//                                 hintText:
//                                     "Search Task / Station / Engineer",

//                                 hintStyle:
//                                     const TextStyle(
//                                   color:
//                                       Colors.white54,
//                                 ),

//                                 filled: true,

//                                 fillColor:
//                                     Colors.white
//                                         .withOpacity(
//                                             0.08),

//                                 prefixIcon:
//                                     const Icon(
//                                   Icons.search,
//                                   color:
//                                       Colors.white,
//                                 ),

//                                 border:
//                                     OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                               14),

//                                   borderSide:
//                                       BorderSide
//                                           .none,
//                                 ),
//                               ),

//                               onChanged:
//                                   (value) {

//                                 filterTasks();
//                               },
//                             ),
//                           ),

//                           const SizedBox(
//                               width: 16),

//                           // STATUS FILTER

//                           Expanded(
//                             flex: 1,

//                             child:
//                                 DropdownButtonFormField<
//                                     String>(

//                               value:
//                                   selectedStatus,

//                               dropdownColor:
//                                   Colors.black,

//                               style:
//                                   const TextStyle(
//                                 color:
//                                     Colors.white,
//                               ),

//                               decoration:
//                                   InputDecoration(

//                                 filled: true,

//                                 fillColor:
//                                     Colors.white
//                                         .withOpacity(
//                                             0.08),

//                                 border:
//                                     OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                               14),

//                                   borderSide:
//                                       BorderSide
//                                           .none,
//                                 ),
//                               ),

//                               items: [

//                                 "All",

//                                 "Pending",

//                                 "In Progress",

//                                 "Completed",

//                               ]
//                                   .map(
//                                     (e) =>
//                                         DropdownMenuItem(
//                                       value: e,

//                                       child:
//                                           Text(e),
//                                     ),
//                                   )
//                                   .toList(),

//                               onChanged:
//                                   (value) {

//                                 selectedStatus =
//                                     value!;

//                                 filterTasks();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // =========================================
//                     // TABLE HEADER
//                     // =========================================

//                     Container(
//                       padding:
//                           const EdgeInsets
//                               .symmetric(
//                         vertical: 14,
//                         horizontal: 16,
//                       ),

//                       margin:
//                           const EdgeInsets
//                               .symmetric(
//                         horizontal: 16,
//                       ),

//                       decoration:
//                           BoxDecoration(
//                         color: Colors.white
//                             .withOpacity(
//                                 0.08),

//                         borderRadius:
//                             BorderRadius
//                                 .circular(
//                                     14),
//                       ),

//                       child: const Row(
//                         children: [

//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Task ID",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Station",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             flex: 2,
//                             child: Text(
//                               "Engineer",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             child: Text(
//                               "Priority",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),

//                           Expanded(
//                             child: Text(
//                               "Status",

//                               style: TextStyle(
//                                 color:
//                                     Colors.white,

//                                 fontWeight:
//                                     FontWeight
//                                         .bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(
//                         height: 10),

//                     // =========================================
//                     // LIST
//                     // =========================================

//                     Expanded(
//                       child:
//                           ListView.builder(

//                         itemCount:
//                             filteredTasks
//                                 .length,

//                         itemBuilder:
//                             (context, index) {

//                           final task =
//                               filteredTasks[
//                                   index];

//                           return Container(
//                             padding:
//                                 const EdgeInsets
//                                     .symmetric(
//                               vertical: 16,
//                               horizontal: 16,
//                             ),

//                             margin:
//                                 const EdgeInsets
//                                     .symmetric(
//                               horizontal: 16,
//                               vertical: 6,
//                             ),

//                             decoration:
//                                 BoxDecoration(
//                               color: Colors
//                                   .white
//                                   .withOpacity(
//                                       0.05),

//                               borderRadius:
//                                   BorderRadius
//                                       .circular(
//                                           14),

//                               border:
//                                   Border.all(
//                                 color:
//                                     Colors
//                                         .white10,
//                               ),
//                             ),

//                             child: Row(
//                               children: [

//                                 Expanded(
//                                   flex: 2,

//                                   child: Text(
//                                     task[
//                                             "task_id"] ??
//                                         "",

//                                     style:
//                                         const TextStyle(
//                                       color:
//                                           Colors
//                                               .white,
//                                     ),
//                                   ),
//                                 ),

//                                 Expanded(
//                                   flex: 2,

//                                   child: Text(
//                                     task[
//                                             "station_name"] ??
//                                         "",

//                                     style:
//                                         const TextStyle(
//                                       color:
//                                           Colors
//                                               .white,
//                                     ),
//                                   ),
//                                 ),

//                                 Expanded(
//                                   flex: 2,

//                                   child: Text(
//                                     task[
//                                                 "assigned_engineer"] ??
//                                             "",

//                                     style:
//                                         const TextStyle(
//                                       color:
//                                           Colors
//                                               .white,
//                                     ),
//                                   ),
//                                 ),

//                                 Expanded(
//                                   child:
//                                       Container(
//                                     padding:
//                                         const EdgeInsets
//                                             .symmetric(
//                                       horizontal:
//                                           10,

//                                       vertical:
//                                           6,
//                                     ),

//                                     decoration:
//                                         BoxDecoration(
//                                       color:
//                                           getPriorityColor(
//                                         task[
//                                                 "priority"] ??
//                                             "",
//                                       ),

//                                       borderRadius:
//                                           BorderRadius
//                                               .circular(
//                                                   10),
//                                     ),

//                                     child: Text(
//                                       task[
//                                               "priority"] ??
//                                           "",

//                                       textAlign:
//                                           TextAlign
//                                               .center,

//                                       style:
//                                           const TextStyle(
//                                         color:
//                                             Colors
//                                                 .white,

//                                         fontWeight:
//                                             FontWeight
//                                                 .bold,

//                                         fontSize:
//                                             12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),

//                                 const SizedBox(
//                                     width: 10),

//                                 Expanded(
//                                   child:
//                                       Container(
//                                     padding:
//                                         const EdgeInsets
//                                             .symmetric(
//                                       horizontal:
//                                           10,

//                                       vertical:
//                                           6,
//                                     ),

//                                     decoration:
//                                         BoxDecoration(
//                                       color:
//                                           getStatusColor(
//                                         task[
//                                                 "status"] ??
//                                             "",
//                                       ),

//                                       borderRadius:
//                                           BorderRadius
//                                               .circular(
//                                                   10),
//                                     ),

//                                     child: Text(
//                                       task[
//                                               "status"] ??
//                                           "",

//                                       textAlign:
//                                           TextAlign
//                                               .center,

//                                       style:
//                                           const TextStyle(
//                                         color:
//                                             Colors
//                                                 .white,

//                                         fontWeight:
//                                             FontWeight
//                                                 .bold,

//                                         fontSize:
//                                             12,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }