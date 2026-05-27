import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EngineerMasterPage extends StatefulWidget {
  const EngineerMasterPage({super.key});

  @override
  State<EngineerMasterPage> createState() =>
      _EngineerMasterPageState();
}

class _EngineerMasterPageState extends State<EngineerMasterPage> {
  List engineers = [];
  bool loading = true;

  // ================= BASE URL =================
  final String baseUrl = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchEngineers();
  }

  // ================= FETCH =================
  Future fetchEngineers() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/engineers-master"),
      );

      if (res.statusCode == 200) {
        setState(() {
          engineers = jsonDecode(res.body);
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
      });

      debugPrint(e.toString());
    }
  }

  // ================= UPDATE =================
  Future updateEngineer(int id, Map data) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/engineers-master/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      final result = jsonDecode(res.body);

      if (result["success"] == true) {
        fetchEngineers();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Updated Successfully"),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= DELETE =================
  Future deleteEngineer(int id) async {
    try {
      await http.delete(
        Uri.parse("$baseUrl/engineers-master/$id"),
      );

      fetchEngineers();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ================= EDIT DIALOG =================
  void editDialog(Map engineer) {
    final imei =
        TextEditingController(text: engineer["imei_number"]);

    final emp =
        TextEditingController(text: engineer["emp_number"]);

    final name =
        TextEditingController(text: engineer["engineer_name"]);

    final location =
        TextEditingController(text: engineer["location"]);

    final phone =
        TextEditingController(text: engineer["phone_number"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Engineer"),

        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: imei,
                decoration:
                    const InputDecoration(labelText: "IMEI"),
              ),

              TextField(
                controller: emp,
                decoration:
                    const InputDecoration(labelText: "Emp No"),
              ),

              TextField(
                controller: name,
                decoration:
                    const InputDecoration(labelText: "Name"),
              ),

              TextField(
                controller: location,
                decoration:
                    const InputDecoration(labelText: "Location"),
              ),

              TextField(
                controller: phone,
                decoration:
                    const InputDecoration(labelText: "Phone"),
              ),
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
              updateEngineer(engineer["id"], {
                "imei_number": imei.text,
                "emp_number": emp.text,
                "engineer_name": name.text,
                "location": location.text,
                "phone_number": phone.text,
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text("Engineer Master"),
        backgroundColor: Colors.black,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: engineers.length,

              itemBuilder: (context, index) {
                final e = engineers[index];

                return Card(
                  color: Colors.white.withOpacity(0.08),

                  child: ListTile(
                    title: Text(
                      e["engineer_name"] ?? "",
                      style:
                          const TextStyle(color: Colors.white),
                    ),

                    subtitle: Text(
                      "EMP: ${e["emp_number"]} | ${e["location"]}",
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.orange,
                          ),
                          onPressed: () => editDialog(e),
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () =>
                              deleteEngineer(e["id"]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}