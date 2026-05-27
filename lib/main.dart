
// import 'package:flutter/material.dart';
// import 'screens/login_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/engineers_screen.dart';
import 'screens/installations_screen.dart';
import 'screens/other_tasks_screen.dart';
import 'screens/complaints_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // START PAGE
      home: const LoginScreen(),

      // ROUTES
      routes: {
        "/admin": (context) => const AdminScreen(),

        // ✅ FIXED: passing required parameter "type"
        "/tasks": (context) => const TasksScreen(type: "admin"),

        "/engineers": (context) => const EngineersScreen(),
        "/installations": (context) => const InstallationsScreen(),
        "/complaints": (context) => const ComplaintsScreen(),
        "/other": (context) => const OtherTasksScreen(),
      },
    );
  }
}