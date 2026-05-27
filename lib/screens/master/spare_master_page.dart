import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpareMasterPage extends StatefulWidget {
  const SpareMasterPage({super.key});

  @override
  State<SpareMasterPage> createState() =>
      _SpareMasterPageState();
}

class _SpareMasterPageState
    extends State<SpareMasterPage> {
  List spares = [];
  bool isLoading = true;
final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchSpares();
  }

  // ================= FETCH =================
  Future<void> fetchSpares() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/spares-register"),
      );

      if (res.statusCode == 200) {
        setState(() {
          spares = jsonDecode(res.body);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= DELETE =================
  Future<void> deleteSpare(int id) async {
    try {
      await http.delete(
        Uri.parse("$baseUrl/delete-spare/$id"),
      );

      fetchSpares();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= UPDATE =================
  Future<void> updateSpare(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      await http.put(
        Uri.parse("$baseUrl/update-spare/$id"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      fetchSpares();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= EDIT DIALOG =================
  void editDialog(Map e) {
    final TextEditingController partNo =
        TextEditingController(
      text: e["part_number"] ?? "",
    );

    final TextEditingController desc =
        TextEditingController(
      text: e["description"] ?? "",
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Spare"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: partNo,
                decoration: const InputDecoration(
                  labelText: "Part Number",
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: desc,
                decoration: const InputDecoration(
                  labelText: "Description",
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
                await updateSpare(
                  e["id"],
                  {
                    "part_number": partNo.text,
                    "description": desc.text,
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
        title: const Text("Spares Master"),
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
                                "Part No",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                "Description",
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

                          rows: spares.map<DataRow>((e) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    e["part_number"] ?? "",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                ),

                                DataCell(
                                  Text(
                                    e["description"] ?? "",
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
                                          deleteSpare(
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