

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


import 'tasks_screen.dart';
import 'complaints/complaint_register_page.dart';
import 'complaints/complaint_reassign_page.dart';
import 'complaints/complaint_overall_page.dart';
import 'installations/installation_register_page.dart';
import 'installations/installation_status_page.dart';
import 'tasks/task_register_page.dart';
import 'tasks/task_overall_page.dart';
import 'tasks/task_reassign_page.dart';
import 'master/engineer_master_page.dart';
import 'master/station_master_page.dart';
import 'master/spare_master_page.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isAdminOpen = false;

  final MapController mapController = MapController();

  LatLng mapCenter = LatLng(20.5937, 78.9629);
  double mapZoom = 4.5;

  // ================= SELECTED ENGINEER =================
  Map<String, dynamic>? selectedEngineer;

  // ================= ENGINEER DATA =================
  final List<Map<String, dynamic>> engineerLocations = [
    {
      "employeeId": "EMP005",
      "engineerName": "John",
      "location": "Hyderabad",
      "point": LatLng(17.3850, 78.4867),
    },
    {
      "employeeId": "EMP001",
      "engineerName": "Rahul",
      "location": "Delhi",
      "point": LatLng(28.6139, 77.2090),
    },
    {
      "employeeId": "EMP002",
      "engineerName": "Kumar",
      "location": "Chennai",
      "point": LatLng(13.0827, 80.2707),
    },
    {
      "employeeId": "EMP003",
      "engineerName": "Arun",
      "location": "Mumbai",
      "point": LatLng(19.0760, 72.8777),
    },
    {
      "employeeId": "EMP004",
      "engineerName": "Vignesh",
      "location": "Bangalore",
      "point": LatLng(12.9716, 77.5946),
    },
  ];

  Map<String, bool> sectionOpen = {
    "Complaints": false,
    "Installation": false,
    "Task": false,
    "Master": false,
    "Spares": false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.35),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Smart Railway Maintenance Portal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),

      body: Stack(
        children: [
          // ================= BACKGROUND =================
          SizedBox.expand(
            child: Image.asset(
              'assets/train.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 12,
                sigmaY: 12,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

          // ================= MAP =================
          Positioned.fill(
            top: 120,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),

                child: FlutterMap(
                  mapController: mapController,
                  
                  options: MapOptions(
                    initialCenter: mapCenter,
                    initialZoom: mapZoom,
                    minZoom: 2,
                    maxZoom: 18,

                    onPositionChanged: (position, _) {
                      mapCenter = position.center ?? mapCenter;
                      mapZoom = position.zoom ?? mapZoom;
                    },
                  ),

                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),

                    // ================= MARKERS =================
                    MarkerLayer(
                      markers: engineerLocations.map((engineer) {
                        return Marker(
                          width: 50,
                          height: 50,
                          point: engineer["point"],

                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedEngineer = engineer;
                              });
                            },

                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 35,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ================= ENGINEER INFO CARD =================
          if (selectedEngineer != null)
            Positioned(
              top: 160,
              left: 24,

              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.75),

                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= HEADER =================
                    Row(
                      children: [
                        const Icon(
                          Icons.engineering,
                          color: Colors.orange,
                          size: 24,
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Text(
                            "Railway Engineer Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),

                        // ================= CLOSE BUTTON =================
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedEngineer = null;
                            });
                          },

                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    _buildInfoRow(
                      "Employee ID",
                      selectedEngineer!["employeeId"],
                    ),

                    const SizedBox(height: 10),

                    _buildInfoRow(
                      "Engineer Name",
                      selectedEngineer!["engineerName"],
                    ),

                    const SizedBox(height: 10),

                    _buildInfoRow(
                      "Location",
                      selectedEngineer!["location"],
                    ),
                  ],
                ),
              ),
            ),

          // ================= ZOOM BUTTONS =================
          Positioned(
            top: 180,
            right: 20,

            child: Column(
              children: [
                FloatingActionButton(
                  mini: true,

                  onPressed: () {
                    mapZoom += 1.5;
                    mapController.move(mapCenter, mapZoom);
                  },

                  child: const Icon(Icons.add),
                ),

                const SizedBox(height: 10),

                FloatingActionButton(
                  mini: true,

                  onPressed: () {
                    mapZoom -= 1.5;
                    mapController.move(mapCenter, mapZoom);
                  },

                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),

          // ================= MENU =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
              ),

              child: SizedBox(
                height: 420,

                child: Stack(
                  clipBehavior: Clip.none,

                  children: [
                    Row(
                      children: [
                        _buildMenuExpanded(
                          "Admin",
                          Icons.admin_panel_settings,
                          [Colors.cyan, Colors.blue],

                          onTap: () {
                            setState(() {
                              isAdminOpen = !isAdminOpen;
                            });
                          },

                          showArrow: true,
                        ),

                        const SizedBox(width: 12),

                        _buildMenuExpanded(
                          "Complaints",
                          Icons.report_problem,
                          [Colors.red, Colors.redAccent],

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TasksScreen(type: "complaint"),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 12),

                        _buildMenuExpanded(
                          "Installations",
                          Icons.build,
                          [Colors.blue, Colors.blueAccent],

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TasksScreen(type: "installation"),
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 12),

                        _buildMenuExpanded(
                          "Other Tasks",
                          Icons.work,
                          [Colors.green, Colors.greenAccent],

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const TasksScreen(type: "other"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // ================= ADMIN DROPDOWN =================
                    if (isAdminOpen)
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isAdminOpen = false;
                            });
                          },

                          child: Stack(
                            children: [
                              Container(color: Colors.transparent),

                              Positioned(
                                top: 85,
                                left: 0,

                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),

                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 15,
                                      sigmaY: 15,
                                    ),

                                    child: Container(
                                      width: 300,
                                      padding: const EdgeInsets.all(12),

                                      decoration: BoxDecoration(
                                        color:
                                            Colors.grey.withOpacity(0.25),

                                        borderRadius:
                                            BorderRadius.circular(22),

                                        border: Border.all(
                                          color:
                                              Colors.white.withOpacity(0.1),
                                        ),
                                      ),

                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,

                                          children: [
                                            _customSection(
                                              "Complaints",
                                              Icons.report,
                                              [
                                                _customItem(
                                                  "Register",
                                                  () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
    const ComplaintRegisterPage(),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                _customItem(
                                                  "Re-Assign",
                                                  () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
    const ComplaintReassignPage(),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                _customItem(
                                                  "Overall Details",
                                                  () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
    const ComplaintOverallPage(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),

_customSection(
  "Installation",
  Icons.build_circle,
  [
    _customItem(
      "Register",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const InstallationRegisterPage(),
          ),
        );
      },
    ),

    _customItem(
      "Overall Details",
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const InstallationStatusPage(),
          ),
        );
      },
    ),
  ],
),
                                            _customSection(
  "Task",
  Icons.task,
  [
    _customItem("Register Task", () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TaskRegisterPage(),
        ),
      );
    }),

    _customItem("Reassign Task", () {
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const TaskReassignPage(),
  ),
);
    }),

    _customItem("All Tasks", () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const TaskOverallPage(),
        ),
      );
    }),
  ],
),

                                            _customSection(
                                              "Master",
                                              Icons.settings,
                                              [
                                               _customItem(
  "Engineer Master",
  () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EngineerMasterPage(),
      ),
    );
  },
),
                                                _customItem(
                                                  "Station Location Master",
                                                  () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            const StationMasterPage(),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                _customItem(
                                                  "Spare Master",
                                                  () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            const EngineerMasterPage(),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),

                                            

                                            // _customSection(
                                            //   "Spares",
                                            //   Icons.precision_manufacturing,
                                            //   [
                                            //     _customItem(
                                            //       "Sent",
                                            //       () {
                                            //         Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (_) =>
                                            //                 const PlaceholderPage(
                                            //               title:
                                            //                   "Spares - Sent",
                                            //             ),
                                            //           ),
                                            //         );
                                            //       },
                                            //     ),

                                            //     _customItem(
                                            //       "Receive",
                                            //       () {
                                            //         Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (_) =>
                                            //                 const PlaceholderPage(
                                            //               title:
                                            //                   "Spares - Receive",
                                            //             ),
                                            //           ),
                                            //         );
                                            //       },
                                            //     ),

                                            //     _customItem(
                                            //       "Overall Status",
                                            //       () {
                                            //         Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (_) =>
                                            //                 const PlaceholderPage(
                                            //               title:
                                            //                   "Spares - Overall Status",
                                            //             ),
                                            //           ),
                                            //         );
                                            //       },
                                            //     ),

                                            //     _customItem(
                                            //       "Stock",
                                            //       () {
                                            //         Navigator.push(
                                            //           context,
                                            //           MaterialPageRoute(
                                            //             builder: (_) =>
                                            //                 const PlaceholderPage(
                                            //               title:
                                            //                   "Spares - Stock",
                                            //             ),
                                            //           ),
                                            //         );
                                            //       },
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  // ================= INFO ROW =================
  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title : ",
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ================= TOP MENU =================
  Widget _buildMenuExpanded(
    String title,
    IconData icon,
    List<Color> colors, {
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: colors),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),

              const SizedBox(width: 8),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (showArrow)
                Icon(
                  isAdminOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= ADMIN SECTION =================
  Widget _customSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    bool open = sectionOpen[title] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              sectionOpen[title] = !open;
            });
          },

          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 8,
            ),

            color: Colors.transparent,

            child: Row(
              children: [
                Icon(icon, color: Colors.black),

                const SizedBox(width: 8),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                Icon(
                  open
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),

        if (open)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
      ],
    );
  }

  // ================= ADMIN ITEM =================
  Widget _customItem(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),

        child: Row(
          children: [
            const SizedBox(width: 18),

            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PLACEHOLDER PAGE =================
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      body: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
   
