// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class InstallationService {

//   // =====================================================
//   // BASE URL
//   // =====================================================

//   static const String baseUrl =
//       "http://10.11.117.141:3000";

//   // =====================================================
//   // REGISTER INSTALLATION
//   // =====================================================

//   static Future<dynamic> registerInstallation({

//     required String installationId,
//     required String stationName,
//     required String zoneName,
//     required String installationType,
//     required String description,
//     required String priority,
//     required String engineer,

//   }) async {

//     final response = await http.post(

//       Uri.parse(
//         "$baseUrl/register-installation",
//       ),

//       headers: {
//         "Content-Type": "application/json",
//       },

//       body: jsonEncode({

//         "installation_id": installationId,
//         "station_name": stationName,
//         "zone_name": zoneName,
//         "installation_type": installationType,
//         "description": description,
//         "priority": priority,
//         "assigned_engineer": engineer,
//       }),
//     );

//     return jsonDecode(response.body);
//   }

//   // =====================================================
//   // GET INSTALLATIONS
//   // =====================================================

//   static Future<List<dynamic>> getInstallations() async {

//     final response = await http.get(

//       Uri.parse(
//         "$baseUrl/installations",
//       ),
//     );

//     return jsonDecode(response.body);
//   }

//   // =====================================================
//   // REASSIGN INSTALLATION
//   // =====================================================

//   static Future<dynamic> reassignInstallation({

//     required int id,
//     required String engineer,

//   }) async {

//     final response = await http.put(

//       Uri.parse(
//         "$baseUrl/reassign-installation/$id",
//       ),

//       headers: {
//         "Content-Type": "application/json",
//       },

//       body: jsonEncode({

//         "assigned_engineer": engineer,
//       }),
//     );

//     return jsonDecode(response.body);
//   }

//   // =====================================================
//   // UPDATE INSTALLATION STATUS
//   // =====================================================

//   static Future<dynamic> updateInstallationStatus({

//     required int id,
//     required String status,

//   }) async {

//     final response = await http.put(

//       Uri.parse(
//         "$baseUrl/update-installation-status/$id",
//       ),

//       headers: {
//         "Content-Type": "application/json",
//       },

//       body: jsonEncode({

//         "status": status,
//       }),
//     );

//     return jsonDecode(response.body);
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;

class InstallationService {

  static Future registerInstallation({

    required String installationId,
    required String stationName,
    required String zoneName,
    required String installationType,
    required String description,
    required String priority,
    required String engineer,

  }) async {

    final url = Uri.parse(
      'http://10.11.117.141:3000/register-installation',
    );

    final response = await http.post(
      url,

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        "installation_id": installationId,
        "station_name": stationName,
        "zone_name": zoneName,
        "installation_type": installationType,
        "description": description,
        "priority": priority,
        "assigned_engineer": engineer,

      }),
    );

    return jsonDecode(response.body);
  }

  // =====================================================
  // GET INSTALLATIONS
  // =====================================================

  static Future<List<dynamic>> getInstallations() async {

    final url = Uri.parse(
      'http://10.11.117.141:3000/installations',
    );

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  // =====================================================
  // REASSIGN INSTALLATION
  // =====================================================

  static Future<dynamic> reassignInstallation({

    required int id,
    required String engineer,

  }) async {

    final url = Uri.parse(
      'http://10.11.117.141:3000/reassign-installation/$id',
    );

    final response = await http.put(

      url,

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        "assigned_engineer": engineer,

      }),
    );

    return jsonDecode(response.body);
  }

  // =====================================================
  // UPDATE INSTALLATION STATUS
  // =====================================================

  static Future<dynamic> updateInstallationStatus({

    required int id,
    required String status,

  }) async {

    final url = Uri.parse(
  'http://localhost:3000/register-installation',
);

    final response = await http.put(

      url,

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        "status": status,

      }),
    );

    return jsonDecode(response.body);
  }
}