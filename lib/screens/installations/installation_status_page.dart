// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// import '../../services/installation_service.dart';

// class InstallationStatusPage extends StatefulWidget {
//   const InstallationStatusPage({super.key});

//   @override
//   State<InstallationStatusPage> createState() =>
//       _InstallationStatusPageState();
// }

// class _InstallationStatusPageState
//     extends State<InstallationStatusPage> {

//   List installations = [];

//   List filteredInstallations = [];

//   bool isLoading = true;

//   final TextEditingController searchController =
//       TextEditingController();

//   String selectedStatus = "All";

//   @override
//   void initState() {
//     super.initState();

//     fetchInstallations();
//   }

//   // =========================================
//   // FETCH INSTALLATIONS
//   // =========================================

//   Future fetchInstallations() async {

//     try {

//       final url = Uri.parse(
//         'http://10.11.117.141:3000/installations',
//       );

//       final response = await http.get(url);

//       if (response.statusCode == 200) {

//         installations =
//             jsonDecode(response.body);

//         filteredInstallations =
//             List.from(installations);

//         setState(() {
//           isLoading = false;
//         });
//       }

//       else {

//         setState(() {
//           isLoading = false;
//         });

//         ScaffoldMessenger.of(context)
//             .showSnackBar(

//           const SnackBar(
//             content: Text(
//               "Failed to load installations",
//             ),
//           ),
//         );
//       }
//     }

//     catch (e) {

//       setState(() {
//         isLoading = false;
//       });

//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         SnackBar(
//           content: Text(
//             "Error: $e",
//           ),
//         ),
//       );
//     }
//   }

//   // =========================================
//   // FILTER
//   // =========================================

//   void filterInstallations() {

//     String query =
//         searchController.text.toLowerCase();

//     setState(() {

//       filteredInstallations =
//           installations.where((installation) {

//         final installationId =
//             installation["installation_id"]
//                 .toString()
//                 .toLowerCase();

//         final station =
//             installation["station_name"]
//                 .toString()
//                 .toLowerCase();

//         final engineer =
//             installation["assigned_engineer"]
//                 .toString()
//                 .toLowerCase();

//         final status =
//             (installation["status"] ?? "")
//                 .toString();

//         final matchesSearch =
//             installationId.contains(query) ||
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

//   Color getPriorityColor(String priority) {

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

//   // =========================================
//   // UPDATE STATUS
//   // =========================================

//   Future updateStatus(
//     int id,
//     String status,
//   ) async {

//     try {

//       final response =
//           await InstallationService
//               .updateInstallationStatus(
//         id: id,
//         status: status,
//       );

//       if (response["success"] == true) {

//         ScaffoldMessenger.of(context)
//             .showSnackBar(

//           SnackBar(
//             content: Text(
//               response["message"],
//             ),
//           ),
//         );

//         await fetchInstallations();

//         filterInstallations();
//       }

//       else {

//         ScaffoldMessenger.of(context)
//             .showSnackBar(

//           SnackBar(
//             content: Text(
//               response["message"] ??
//                   "Update failed",
//             ),
//           ),
//         );
//       }
//     }

//     catch (e) {

//       ScaffoldMessenger.of(context)
//           .showSnackBar(

//         SnackBar(
//           content: Text(
//             "Error: $e",
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       backgroundColor:
//           const Color(0xFF0F172A),

//       appBar: AppBar(
//         title: const Text(
//           "Installation Overall Details",
//         ),

//         backgroundColor: Colors.black,
//       ),

//       body: isLoading

//           ? const Center(
//               child:
//                   CircularProgressIndicator(),
//             )

//           : Column(
//               children: [

//                 // =========================================
//                 // FILTERS
//                 // =========================================

//                 Padding(
//                   padding:
//                       const EdgeInsets.all(16),

//                   child: Row(
//                     children: [

//                       // SEARCH

//                       Expanded(
//                         flex: 3,

//                         child: TextField(
//                           controller:
//                               searchController,

//                           style:
//                               const TextStyle(
//                             color:
//                                 Colors.white,
//                           ),

//                           decoration:
//                               InputDecoration(

//                             hintText:
//                                 "Search Installation / Station / Engineer",

//                             hintStyle:
//                                 const TextStyle(
//                               color:
//                                   Colors.white54,
//                             ),

//                             filled: true,

//                             fillColor:
//                                 Colors.white
//                                     .withOpacity(
//                                         0.08),

//                             prefixIcon:
//                                 const Icon(
//                               Icons.search,
//                               color:
//                                   Colors.white,
//                             ),

//                             border:
//                                 OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius
//                                       .circular(
//                                           14),

//                               borderSide:
//                                   BorderSide.none,
//                             ),
//                           ),

//                           onChanged: (value) {
//                             filterInstallations();
//                           },
//                         ),
//                       ),

//                       const SizedBox(width: 16),

//                       // STATUS FILTER

//                       Expanded(
//                         flex: 1,

//                         child:
//                             DropdownButtonFormField<
//                                 String>(

//                           value:
//                               selectedStatus,

//                           dropdownColor:
//                               Colors.black,

//                           style:
//                               const TextStyle(
//                             color:
//                                 Colors.white,
//                           ),

//                           decoration:
//                               InputDecoration(

//                             filled: true,

//                             fillColor:
//                                 Colors.white
//                                     .withOpacity(
//                                         0.08),

//                             border:
//                                 OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius
//                                       .circular(
//                                           14),

//                               borderSide:
//                                   BorderSide.none,
//                             ),
//                           ),

//                           items: [

//                             "All",

//                             "Pending",

//                             "In Progress",

//                             "Completed",

//                           ]
//                               .map(
//                                 (e) =>
//                                     DropdownMenuItem(
//                                   value: e,

//                                   child:
//                                       Text(e),
//                                 ),
//                               )
//                               .toList(),

//                           onChanged: (value) {

//                             selectedStatus =
//                                 value!;

//                             filterInstallations();
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // =========================================
//                 // HEADER
//                 // =========================================

//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(
//                     vertical: 14,
//                     horizontal: 16,
//                   ),

//                   margin:
//                       const EdgeInsets.symmetric(
//                     horizontal: 16,
//                   ),

//                   decoration: BoxDecoration(
//                     color: Colors.white
//                         .withOpacity(0.08),

//                     borderRadius:
//                         BorderRadius.circular(
//                             14),
//                   ),

//                   child: const Row(
//                     children: [

//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "Install ID",

//                           style: TextStyle(
//                             color: Colors.white,

//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "Station",

//                           style: TextStyle(
//                             color: Colors.white,

//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         flex: 2,
//                         child: Text(
//                           "Engineer",

//                           style: TextStyle(
//                             color: Colors.white,

//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         child: Text(
//                           "Priority",

//                           style: TextStyle(
//                             color: Colors.white,

//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         child: Text(
//                           "Status",

//                           style: TextStyle(
//                             color: Colors.white,

//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),

//                       Expanded(
//                         child: Text(
//                           "Action",

//                           style: TextStyle(
//                             color: Colors.white,

//                             fontWeight:
//                                 FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 // =========================================
//                 // LIST
//                 // =========================================

//                 Expanded(
//                   child: ListView.builder(

//                     itemCount:
//                         filteredInstallations
//                             .length,

//                     itemBuilder:
//                         (context, index) {

//                       final installation =
//                           filteredInstallations[
//                               index];

//                       return Container(
//                         padding:
//                             const EdgeInsets
//                                 .symmetric(
//                           vertical: 16,
//                           horizontal: 16,
//                         ),

//                         margin:
//                             const EdgeInsets
//                                 .symmetric(
//                           horizontal: 16,
//                           vertical: 6,
//                         ),

//                         decoration:
//                             BoxDecoration(
//                           color: Colors.white
//                               .withOpacity(
//                                   0.05),

//                           borderRadius:
//                               BorderRadius
//                                   .circular(
//                                       14),

//                           border: Border.all(
//                             color:
//                                 Colors.white10,
//                           ),
//                         ),

//                         child: Row(
//                           children: [

//                             Expanded(
//                               flex: 2,

//                               child: Text(
//                                 installation[
//                                         "installation_id"] ??
//                                     "",

//                                 style:
//                                     const TextStyle(
//                                   color:
//                                       Colors.white,
//                                 ),
//                               ),
//                             ),

//                             Expanded(
//                               flex: 2,

//                               child: Text(
//                                 installation[
//                                         "station_name"] ??
//                                     "",

//                                 style:
//                                     const TextStyle(
//                                   color:
//                                       Colors.white,
//                                 ),
//                               ),
//                             ),

//                             Expanded(
//                               flex: 2,

//                               child: Text(
//                                 installation[
//                                             "assigned_engineer"] ??
//                                         "",

//                                 style:
//                                     const TextStyle(
//                                   color:
//                                       Colors.white,
//                                 ),
//                               ),
//                             ),

//                             Expanded(
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets
//                                         .symmetric(
//                                   horizontal:
//                                       10,

//                                   vertical: 6,
//                                 ),

//                                 decoration:
//                                     BoxDecoration(
//                                   color:
//                                       getPriorityColor(
//                                     installation[
//                                             "priority"] ??
//                                         "",
//                                   ),

//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                               10),
//                                 ),

//                                 child: Text(
//                                   installation[
//                                           "priority"] ??
//                                       "",

//                                   textAlign:
//                                       TextAlign
//                                           .center,

//                                   style:
//                                       const TextStyle(
//                                     color:
//                                         Colors
//                                             .white,

//                                     fontWeight:
//                                         FontWeight
//                                             .bold,

//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 10),

//                             Expanded(
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets
//                                         .symmetric(
//                                   horizontal:
//                                       10,

//                                   vertical: 6,
//                                 ),

//                                 decoration:
//                                     BoxDecoration(
//                                   color:
//                                       getStatusColor(
//                                     installation[
//                                             "status"] ??
//                                         "",
//                                   ),

//                                   borderRadius:
//                                       BorderRadius
//                                           .circular(
//                                               10),
//                                 ),

//                                 child: Text(
//                                   installation[
//                                           "status"] ??
//                                       "",

//                                   textAlign:
//                                       TextAlign
//                                           .center,

//                                   style:
//                                       const TextStyle(
//                                     color:
//                                         Colors
//                                             .white,

//                                     fontWeight:
//                                         FontWeight
//                                             .bold,

//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             const SizedBox(width: 10),

//                             Expanded(
//                               child:
//                                   PopupMenuButton(

//                                 color:
//                                     Colors.black,

//                                 onSelected:
//                                     (value) {

//                                   updateStatus(
//                                     installation[
//                                         "id"],
//                                     value,
//                                   );
//                                 },

//                                 itemBuilder:
//                                     (context) => [

//                                   const PopupMenuItem(
//                                     value:
//                                         "Pending",

//                                     child: Text(
//                                       "Pending",
//                                     ),
//                                   ),

//                                   const PopupMenuItem(
//                                     value:
//                                         "In Progress",

//                                     child: Text(
//                                       "In Progress",
//                                     ),
//                                   ),

//                                   const PopupMenuItem(
//                                     value:
//                                         "Completed",

//                                     child: Text(
//                                       "Completed",
//                                     ),
//                                   ),
//                                 ],

//                                 child: Container(
//                                   padding:
//                                       const EdgeInsets
//                                           .symmetric(
//                                     horizontal:
//                                         12,

//                                     vertical: 8,
//                                   ),

//                                   decoration:
//                                       BoxDecoration(
//                                     color: Colors
//                                         .blue,

//                                     borderRadius:
//                                         BorderRadius
//                                             .circular(
//                                                 10),
//                                   ),

//                                   child: const Text(
//                                     "Update",

//                                     textAlign:
//                                         TextAlign
//                                             .center,

//                                     style:
//                                         TextStyle(
//                                       color: Colors
//                                           .white,

//                                       fontWeight:
//                                           FontWeight
//                                               .bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InstallationStatusPage extends StatefulWidget {
  const InstallationStatusPage({super.key});

  @override
  State<InstallationStatusPage> createState() =>
      _InstallationStatusPageState();
}

class _InstallationStatusPageState
    extends State<InstallationStatusPage> {

  List installations = [];
  List filteredInstallations = [];

  bool isLoading = true;

  final TextEditingController searchController =
      TextEditingController();

  String selectedStatus = "All";

  final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchInstallations();
  }

  // =========================================
  // FETCH INSTALLATIONS
  // =========================================

  Future<void> fetchInstallations() async {

    try {

      final response = await http.get(
        Uri.parse("$baseUrl/installations"),
      );

      if (response.statusCode == 200) {

        final data = jsonDecode(response.body);

        setState(() {

          installations = data;

          filteredInstallations =
              List.from(installations);

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
              "Server Error: ${response.statusCode}",
            ),
          ),
        );
      }
    }

    catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  // =========================================
  // FILTER
  // =========================================

  void filterInstallations() {

    String query =
        searchController.text.toLowerCase();

    setState(() {

      filteredInstallations =
          installations.where((installation) {

        final installationId =
            installation["installation_id"]
                .toString()
                .toLowerCase();

        final station =
            installation["station_name"]
                .toString()
                .toLowerCase();

        final engineer =
            installation["assigned_engineer"]
                .toString()
                .toLowerCase();

        final status =
            installation["status"]
                .toString();

        final matchesSearch =
            installationId.contains(query) ||
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

  // =========================================
  // UPDATE STATUS
  // =========================================

  Future<void> updateStatus(
    int id,
    String status,
  ) async {

    try {

      final response = await http.put(

        Uri.parse(
          "$baseUrl/update-installation-status/$id",
        ),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({
          "status": status,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (data["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text("Status Updated"),
          ),
        );

        fetchInstallations();
      }

      else {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text("Update Failed"),
          ),
        );
      }
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text(
          "Installation Overall Details",
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
                // SEARCH + FILTER
                // =========================================

                Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Row(
                    children: [

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
                                "Search Installation / Station / Engineer",

                            hintStyle:
                                const TextStyle(
                              color:
                                  Color.fromARGB(255, 243, 240, 240),
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
                            filterInstallations();
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

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

                            filterInstallations();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================================
                // LIST
                // =========================================

                Expanded(
                  child: ListView.builder(

                    itemCount:
                        filteredInstallations
                            .length,

                    itemBuilder:
                        (context, index) {

                      final installation =
                          filteredInstallations[
                              index];

                      return Card(

                        color: Colors.white
                            .withOpacity(0.06),

                        margin:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),

                        child: ListTile(

                          title: Text(

                            installation[
                                    "installation_id"] ??
                                "",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          subtitle: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              const SizedBox(
                                  height: 8),

                              Text(
                                "Station: ${installation["station_name"] ?? ""}",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),

                              Text(
                                "Engineer: ${installation["assigned_engineer"] ?? ""}",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white70,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              Row(
                                children: [

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          getPriorityColor(
                                        installation[
                                                "priority"] ??
                                            "",
                                      ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  10),
                                    ),

                                    child: Text(
                                      installation[
                                              "priority"] ??
                                          "",

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors
                                                .white,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 10),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          getStatusColor(
                                        installation[
                                                "status"] ??
                                            "",
                                      ),

                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  10),
                                    ),

                                    child: Text(
                                      installation[
                                              "status"] ??
                                          "",

                                      style:
                                          const TextStyle(
                                        color:
                                            Colors
                                                .white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          trailing:
                              PopupMenuButton(

                            color: Colors.black,

                            onSelected:
                                (value) {

                              updateStatus(
                                installation[
                                    "id"],
                                value,
                              );
                            },

                            itemBuilder:
                                (context) => [

                              const PopupMenuItem(
                                value:
                                    "Pending",
                                child:
                                    Text("Pending"),
                              ),

                              const PopupMenuItem(
                                value:
                                    "In Progress",
                                child:
                                    Text(
                                        "In Progress"),
                              ),

                              const PopupMenuItem(
                                value:
                                    "Completed",
                                child:
                                    Text(
                                        "Completed"),
                              ),
                            ],
                          ),
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