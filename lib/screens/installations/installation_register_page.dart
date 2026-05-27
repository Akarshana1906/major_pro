import 'dart:ui';

import 'package:flutter/material.dart';

import '../../services/installation_service.dart';

class InstallationRegisterPage extends StatefulWidget {
  const InstallationRegisterPage({super.key});

  @override
  State<InstallationRegisterPage> createState() =>
      _InstallationRegisterPageState();
}

class _InstallationRegisterPageState
    extends State<InstallationRegisterPage> {

  final stationController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  String priority = "Medium";

  bool isLoading = false;

  Future<void> registerInstallation() async {

    setState(() {
      isLoading = true;
    });

    final response =
        await InstallationService
            .registerInstallation(
      installationId:
          "INS${DateTime.now().millisecondsSinceEpoch}",
      stationName:
          stationController.text,
      zoneName: "South Zone",
      installationType: "Signal System",
      description:
          descriptionController.text,
      priority: priority,
      engineer: "Rahul",
    );

    setState(() {
      isLoading = false;
    });

    if (response["success"] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Installation Registered Successfully",
          ),
        ),
      );

      stationController.clear();
      descriptionController.clear();

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response["message"].toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor:
            Colors.black.withOpacity(0.3),
        elevation: 0,
        title: const Text(
          "Installation Register",
        ),
      ),

      body: Stack(
        children: [

          /// BACKGROUND
          SizedBox.expand(
            child: Image.asset(
              "assets/train.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// BLUR
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 12,
                sigmaY: 12,
              ),

              child: Container(
                color:
                    const Color.fromARGB(255, 246, 245, 245).withOpacity(0.3),
              ),
            ),
          ),

          /// FORM
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 500,
                margin:
                    const EdgeInsets.all(20),

                padding:
                    const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(25),

                  color: Colors.white
                      .withOpacity(0.12),

                  border: Border.all(
                    color:
                        Colors.white24,
                  ),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Register Installation",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// STATION
                    TextField(
                      controller:
                          stationController,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(
                        labelText:
                            "Station Name",

                        labelStyle:
                            const TextStyle(
                          color:
                              Colors.white70,
                        ),

                        filled: true,

                        fillColor:
                            Colors.white
                                .withOpacity(0.08),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// DESCRIPTION
                    TextField(
                      controller:
                          descriptionController,

                      maxLines: 4,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(
                        labelText:
                            "Description",

                        labelStyle:
                            const TextStyle(
                          color:
                              Colors.white70,
                        ),

                        filled: true,

                        fillColor:
                            Colors.white
                                .withOpacity(0.08),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PRIORITY
                    DropdownButtonFormField<String>(
                      value: priority,

                      dropdownColor:
                          Colors.black87,

                      style: const TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(
                        filled: true,

                        fillColor:
                            Colors.white
                                .withOpacity(0.08),

                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(15),
                        ),
                      ),

                      items: [
                        "Low",
                        "Medium",
                        "High",
                      ]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (value) {

                        setState(() {
                          priority = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,

                      height: 55,

                      child: ElevatedButton(

                        onPressed:
                            isLoading
                                ? null
                                : registerInstallation,

                        style: ElevatedButton
                            .styleFrom(
                          backgroundColor:
                              Colors.blueAccent,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(16),
                          ),
                        ),

                        child:
                            isLoading
                                ? const CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                  )
                                : const Text(
                                    "Register Installation",
                                    style:
                                        TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
