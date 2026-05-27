

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplaintReassignPage extends StatefulWidget {
  const ComplaintReassignPage({super.key});

  @override
  State<ComplaintReassignPage> createState() =>
      _ComplaintReassignPageState();
}

class _ComplaintReassignPageState
    extends State<ComplaintReassignPage> {

  List complaints = [];

  bool isLoading = true;

  final String baseUrl =
      "http://localhost:3000";

  final List<String> engineers = [
    "Rahul",
    "Kumar",
    "Arun",
    "Vignesh",
    "John",
  ];

  @override
  void initState() {
    super.initState();

    fetchComplaints();
  }

  // =========================================
  // FETCH COMPLAINTS
  // =========================================
  Future fetchComplaints() async {

    try {

      final url = Uri.parse(
        '$baseUrl/complaints',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {

        setState(() {

          complaints =
              jsonDecode(response.body);

          isLoading = false;
        });

      } else {

        setState(() {
          isLoading = false;
        });

        debugPrint(
          "Failed: ${response.statusCode}",
        );
      }

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================
  // REASSIGN COMPLAINT
  // =========================================
  Future reassignComplaint(
    int complaintId,
    String engineer,
  ) async {

    try {

      final url = Uri.parse(
        '$baseUrl/reassign-complaint/$complaintId',
      );

      final response = await http.put(
        url,

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({
          "assigned_engineer": engineer,
        }),
      );

      final data =
          jsonDecode(response.body);

      if (data["success"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text("Complaint Reassigned"),
          ),
        );

        fetchComplaints();

      } else {

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content:
                Text("Reassign Failed"),
          ),
        );
      }

    } catch (e) {

      debugPrint(e.toString());

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
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
          "Complaint Reassign",
        ),

        backgroundColor: const Color.fromARGB(255, 45, 45, 52),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : complaints.isEmpty

              ? const Center(
                  child: Text(
                    "No Complaints Found",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )

              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),

                  itemCount:
                      complaints.length,

                  itemBuilder:
                      (context, index) {

                    final complaint =
                        complaints[index];

                    String selectedEngineer =
                        complaint[
                                "assigned_engineer"] ??
                            engineers.first;

                    if (!engineers.contains(
                        selectedEngineer)) {

                      selectedEngineer =
                          engineers.first;
                    }

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                          const EdgeInsets.all(
                              16),

                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.08),

                        borderRadius:
                            BorderRadius
                                .circular(18),

                        border: Border.all(
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
                                Icons
                                    .report_problem,
                                color: Colors.red,
                              ),

                              const SizedBox(
                                  width: 10),

                              Expanded(
                                child: Text(
                                  complaint[
                                          "complaint_id"] ??
                                      "",

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,

                                    fontSize: 18,

                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                              height: 14),

                          // ================= DETAILS =================

                          _infoRow(
                            "Station",
                            complaint[
                                    "station_name"] ??
                                "",
                          ),

                          _infoRow(
                            "Zone",
                            complaint[
                                    "zone_name"] ??
                                "",
                          ),

                          _infoRow(
                            "Type",
                            complaint[
                                    "complaint_type"] ??
                                "",
                          ),

                          _infoRow(
                            "Priority",
                            complaint[
                                    "priority"] ??
                                "",
                          ),

                          _infoRow(
                            "Status",
                            complaint[
                                    "status"] ??
                                "",
                          ),

                          _infoRow(
                            "Current Engineer",
                            complaint[
                                    "assigned_engineer"] ??
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

                              fillColor: Colors
                                  .white
                                  .withOpacity(
                                      0.08),

                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            14),

                                borderSide:
                                    BorderSide
                                        .none,
                              ),
                            ),

                            items: engineers
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

                              selectedEngineer =
                                  value!;
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

                                reassignComplaint(
                                  complaint["id"],
                                  selectedEngineer,
                                );
                              },

                              child: const Text(
                                "Reassign Complaint",

                                style: TextStyle(
                                  color:
                                      Colors.white,

                                  fontWeight:
                                      FontWeight
                                          .bold,
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

  // =========================================
  // INFO ROW
  // =========================================
  Widget _infoRow(
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
            width: 140,

            child: Text(
              "$title :",

              style: const TextStyle(
                color: Colors.orange,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}