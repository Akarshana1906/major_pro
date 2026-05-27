import 'package:flutter/material.dart';

import '../../services/complaint_service.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/glass_card.dart';

class ComplaintRegisterPage extends StatefulWidget {
  const ComplaintRegisterPage({super.key});

  @override
  State<ComplaintRegisterPage> createState() =>
      _ComplaintRegisterPageState();
}

class _ComplaintRegisterPageState
    extends State<ComplaintRegisterPage> {

  // ================= CONTROLLERS =================

  final TextEditingController complaintIdController =
      TextEditingController();

  final TextEditingController stationController =
      TextEditingController();

  final TextEditingController zoneController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  // ================= DROPDOWNS =================

  String complaintType = "Signal Issue";

  String priority = "Medium";

  String engineer = "Rahul";

  bool isLoading = false;

  // ================= REGISTER FUNCTION =================

  Future<void> registerComplaint() async {

    setState(() {
      isLoading = true;
    });

    try {

      final response =
          await ComplaintService.registerComplaint(
        complaintId:
            complaintIdController.text.trim(),

        stationName:
            stationController.text.trim(),

        zoneName:
            zoneController.text.trim(),

        complaintType: complaintType,

        description:
            descriptionController.text.trim(),

        priority: priority,

        engineer: engineer,
      );

      if (response["success"] == true) {

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Complaint Registered"),
            ),
          );
        }

        // ================= CLEAR FIELDS =================

        complaintIdController.clear();

        stationController.clear();

        zoneController.clear();

        descriptionController.clear();

        setState(() {
          complaintType = "Signal Issue";
          priority = "Medium";
          engineer = "Rahul";
        });

      } else {

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Registration Failed"),
            ),
          );
        }
      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error : $e",
          ),
        ),
      );

    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xFF0F172A),

      appBar: AppBar(
        title: const Text(
          "Complaint Register",
        ),

        centerTitle: true,

        backgroundColor: const Color.fromARGB(255, 45, 45, 52),

        elevation: 0,
      ),

      body: Stack(
        children: [

          // ================= BACKGROUND =================

          Positioned.fill(
            child: Image.asset(
              'assets/train.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.55),
            ),
          ),

          // ================= BODY =================

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(24),

                child: GlassCard(
                  width: 700,

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      // ================= TITLE =================

                      const Text(
                        "Register New Complaint",

                        style: TextStyle(
                          color: Colors.white,

                          fontSize: 28,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Railway Complaint Management System",

                        style: TextStyle(
                          color: Colors.white70,

                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= ROW 1 =================

                      Row(
                        children: [

                          Expanded(
                            child: CustomTextField(
                              hint:
                                  "Complaint ID",

                              controller:
                                  complaintIdController,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: CustomTextField(
                              hint:
                                  "Station Name",

                              controller:
                                  stationController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ================= ROW 2 =================

                      Row(
                        children: [

                          Expanded(
                            child: CustomTextField(
                              hint:
                                  "Zone Name",

                              controller:
                                  zoneController,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child:
                                DropdownButtonFormField<String>(

                              value: complaintType,

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
                                      BorderSide
                                          .none,
                                ),
                              ),

                              items: [

                                "Signal Issue",

                                "Power Failure",

                                "Hardware Issue",

                                "Software Issue",

                                "Installation Issue",

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

                                setState(() {
                                  complaintType =
                                      value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // ================= DESCRIPTION =================

                      CustomTextField(
                        hint:
                            "Complaint Description",

                        controller:
                            descriptionController,

                        maxLines: 5,
                      ),

                      const SizedBox(height: 18),

                      // ================= ROW 3 =================

                      Row(
                        children: [

                          Expanded(
                            child:
                                DropdownButtonFormField<String>(

                              value: priority,

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
                                      BorderSide
                                          .none,
                                ),
                              ),

                              items: [

                                "Low",

                                "Medium",

                                "High",

                                "Emergency",

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

                                setState(() {
                                  priority =
                                      value!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child:
                                DropdownButtonFormField<String>(

                              value: engineer,

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
                                      BorderSide
                                          .none,
                                ),
                              ),

                              items: [

                                "Rahul",

                                "Kumar",

                                "Arun",

                                "Vignesh",

                                "John",

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

                                setState(() {
                                  engineer =
                                      value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ================= BUTTONS =================

                      Row(
                        children: [

                          Expanded(
                            child: ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(

                                backgroundColor:
                                    Colors.redAccent,

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 18,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              16),
                                ),
                              ),

                              onPressed:
                                  isLoading
                                      ? null
                                      : registerComplaint,

                              child:
                                  isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,

                                          child:
                                              CircularProgressIndicator(
                                            color:
                                                Colors
                                                    .white,

                                            strokeWidth:
                                                2,
                                          ),
                                        )
                                      : const Text(
                                          "Register Complaint",

                                          style:
                                              TextStyle(
                                            color:
                                                Colors
                                                    .white,

                                            fontSize:
                                                16,

                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(

                                backgroundColor:
                                    Colors.grey[800],

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 18,
                                ),

                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              16),
                                ),
                              ),

                              onPressed: () {

                                complaintIdController
                                    .clear();

                                stationController
                                    .clear();

                                zoneController
                                    .clear();

                                descriptionController
                                    .clear();
                              },

                              child: const Text(
                                "Reset",

                                style: TextStyle(
                                  color:
                                      Colors.white,

                                  fontSize: 16,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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