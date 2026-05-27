import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List data = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final url = Uri.parse("http://YOUR_IP:3000/spares");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        setState(() {
          data = json.decode(res.body);
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  int get totalSpares => data.length;

  int get lowStock =>
      data.where((e) => e['quantity'] < 10).length;

  Map<String, int> get categoryCount {
    Map<String, int> map = {};
    for (var e in data) {
      map[e['category']] = (map[e['category']] ?? 0) + 1;
    }
    return map;
  }

  Map<String, int> get depotCount {
    Map<String, int> map = {};
    for (var e in data) {
      map[e['location']] = (map[e['location']] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spare Report"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ================= SUMMARY CARDS =================
                    Row(
                      children: [
                        reportCard("Total Spares", totalSpares.toString()),
                        reportCard("Low Stock", lowStock.toString()),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ================= CATEGORY REPORT =================
                    const Text(
                      "Category Report",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    ...categoryCount.entries.map((e) {
                      return ListTile(
                        leading: const Icon(Icons.category),
                        title: Text(e.key),
                        trailing: Text(e.value.toString()),
                      );
                    }),

                    const Divider(),

                    // ================= DEPOT REPORT =================
                    const Text(
                      "Depot Report",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    ...depotCount.entries.map((e) {
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(e.key),
                        trailing: Text(e.value.toString()),
                      );
                    }),

                    const Divider(),

                    // ================= LOW STOCK =================
                    const Text(
                      "Low Stock Items",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    const SizedBox(height: 5),

                    ...data
                        .where((e) => e['quantity'] < 10)
                        .map((e) {
                      return Card(
                        color: Colors.red.shade50,
                        child: ListTile(
                          leading: const Icon(Icons.warning,
                              color: Colors.red),
                          title: Text(e['spare_name']),
                          subtitle: Text(
                              "Code: ${e['spare_code']} | Qty: ${e['quantity']}"),
                        ),
                      );
                    }),

                    const Divider(),

                    // ================= FULL TABLE =================
                    const Text(
                      "All Spare Details",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Code")),
                          DataColumn(label: Text("Category")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Location")),
                        ],
                        rows: data.map((e) {
                          return DataRow(cells: [
                            DataCell(Text(e['spare_name'])),
                            DataCell(Text(e['spare_code'])),
                            DataCell(Text(e['category'])),
                            DataCell(Text(e['quantity'].toString())),
                            DataCell(Text(e['location'])),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= CARD WIDGET =================
  Widget reportCard(String title, String value) {
    return Expanded(
      child: Card(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}