import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/engineer_model.dart';

class EngineersScreen extends StatefulWidget {

  const EngineersScreen({super.key});

  @override
  State<EngineersScreen> createState() =>
      _EngineersScreenState();
}

class _EngineersScreenState
    extends State<EngineersScreen> {

  List<EngineerModel> engineers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEngineers();
  }

  /// ✅ FETCH ENGINEERS
  Future<void> fetchEngineers() async {

    try {

      final response = await http.get(

        Uri.parse(
          "http://10.70.140.141:3000/engineers",
        ),
      );

      print(response.body);

      final data =
          jsonDecode(response.body);

      List<EngineerModel> loadedEngineers =
          [];

      for (var item in data) {

        loadedEngineers.add(
          EngineerModel.fromJson(item),
        );
      }

      setState(() {

        engineers = loadedEngineers;

        isLoading = false;
      });

    } catch (e) {

      print(e);

      setState(() {

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Engineers",
        ),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount: engineers.length,

              itemBuilder:
                  (context, index) {

                final engineer =
                    engineers[index];

                return Card(

                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),

                  elevation: 4,

                  child: Padding(

                    padding:
                        const EdgeInsets.all(
                      16,
                    ),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        /// NAME
                        Text(

                          engineer.name,

                          style:
                              const TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        /// EMPLOYEE ID
                        Row(
                          children: [

                            const Icon(
                              Icons.badge,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Text(
                              engineer.empId,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        /// PHONE
                        Row(
                          children: [

                            const Icon(
                              Icons.phone,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Text(
                              engineer.phone,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        /// LATITUDE
                        Row(
                          children: [

                            const Icon(
                              Icons.location_on,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Text(
                              "Lat: ${engineer.latitude}",
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        /// LONGITUDE
                        Row(
                          children: [

                            const Icon(
                              Icons.location_on_outlined,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Text(
                              "Lng: ${engineer.longitude}",
                            ),
                          ],
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