import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StationMasterPage extends StatefulWidget {
  const StationMasterPage({super.key});

  @override
  State<StationMasterPage> createState() =>
      _StationMasterPageState();
}

class _StationMasterPageState
    extends State<StationMasterPage> {
  List stations = [];
  bool isLoading = true;

  final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  // ================= FETCH =================
  Future<void> fetchStations() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/station-master"),
      );

      if (res.statusCode == 200) {
        setState(() {
          stations = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= DELETE =================
  Future<void> deleteStation(int id) async {
    try {
      await http.delete(
        Uri.parse("$baseUrl/delete-station/$id"),
      );

      fetchStations();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= UPDATE =================
  Future<void> updateStation(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      await http.put(
        Uri.parse("$baseUrl/update-station/$id"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      fetchStations();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= EDIT DIALOG =================
  void editDialog(Map e) {
    final TextEditingController stationName =
        TextEditingController(
      text: e["station_name"] ?? "",
    );

    final TextEditingController division =
        TextEditingController(
      text: e["division"] ?? "",
    );

    final TextEditingController state =
        TextEditingController(
      text: e["state"] ?? "",
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Station"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stationName,
                decoration: const InputDecoration(
                  labelText: "Station Name",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: division,
                decoration: const InputDecoration(
                  labelText: "Division",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: state,
                decoration: const InputDecoration(
                  labelText: "State",
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                await updateStation(
                  e["id"],
                  {
                    "station_name": stationName.text,
                    "division": division.text,
                    "state": state.text,
                  },
                );

                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Station Master"),
        backgroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          // ================= BACKGROUND =================
          Positioned.fill(
            child: Image.asset(
              "assets/train.jpg",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          // ================= TABLE =================
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,

                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color:
                              Colors.white.withOpacity(0.1),

                          borderRadius:
                              BorderRadius.circular(20),

                          border: Border.all(
                            color: Colors.white24,
                          ),
                        ),

                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(
                            Colors.black45,
                          ),

                          columns: const [
                            DataColumn(
                              label: Text(
                                "Station Name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                "Division",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                "State",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                "Actions",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],

                          rows: stations.map<DataRow>((e) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    e["station_name"] ?? "",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    e["division"] ?? "",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    e["state"] ?? "",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color:
                                              Colors.orange,
                                        ),
                                        onPressed: () {
                                          editDialog(e);
                                        },
                                      ),

                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteStation(
                                            e["id"],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
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