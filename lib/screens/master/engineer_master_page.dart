

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EngineerMasterPage extends StatefulWidget {
  const EngineerMasterPage({super.key});

  @override
  State<EngineerMasterPage> createState() => _EngineerMasterPageState();
}

class _EngineerMasterPageState extends State<EngineerMasterPage> {
  List engineers = [];
  bool isLoading = true;

  final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchEngineers();
  }

  // ================= FETCH =================
  Future fetchEngineers() async {
    final res = await http.get(Uri.parse("$baseUrl/engineers-register"));

    if (res.statusCode == 200) {
      setState(() {
        engineers = jsonDecode(res.body);
        isLoading = false;
      });
    }
  }

  // ================= DELETE =================
  Future deleteEngineer(int id) async {
    await http.delete(Uri.parse("$baseUrl/delete-engineer/$id"));
    fetchEngineers();
  }

  // ================= UPDATE =================
  Future updateEngineer(int id, Map data) async {
    await http.put(
      Uri.parse("$baseUrl/update-engineer/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    fetchEngineers();
  }

  // ================= EDIT DIALOG =================
  void editDialog(Map e) {
    final imei = TextEditingController(text: e["imei_number"]);
    final emp = TextEditingController(text: e["emp_number"]);
    final name = TextEditingController(text: e["engineer_name"]);
    final location = TextEditingController(text: e["location"]);
    final phone = TextEditingController(text: e["phone_number"]);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Engineer"),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(controller: imei, decoration: const InputDecoration(labelText: "IMEI Number")),
                TextField(controller: emp, decoration: const InputDecoration(labelText: "Emp Number")),
                TextField(controller: name, decoration: const InputDecoration(labelText: "Engineer Name")),
                TextField(controller: location, decoration: const InputDecoration(labelText: "Location")),
                TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone Number")),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                updateEngineer(e["id"], {
                  "imei_number": imei.text,
                  "emp_number": emp.text,
                  "engineer_name": name.text,
                  "location": location.text,
                  "phone_number": phone.text,
                });

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
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: const Text("Engineer Master"),
        backgroundColor: Colors.black,
      ),

      body: Stack(
        children: [
          // ================= TRAIN BACKGROUND =================
          SizedBox.expand(
            child: Image.asset(
              "assets/train.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // ================= DARK OVERLAY =================
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // ================= CENTERED TABLE =================
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),

                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(Colors.black45),

                          columns: const [
                            DataColumn(
                              label: Text("IMEI",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text("Emp No",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text("Name",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text("Location",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text("Phone",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            DataColumn(
                              label: Text("Actions",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],

                          rows: engineers.map<DataRow>((e) {
                            return DataRow(
                              cells: [
                                DataCell(Text(
                                  e["imei_number"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(Text(
                                  e["emp_number"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(Text(
                                  e["engineer_name"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(Text(
                                  e["location"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                )),
                                DataCell(Text(
                                  e["phone_number"] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                )),

                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.orange),
                                        onPressed: () => editDialog(e),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            deleteEngineer(e["id"]),
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