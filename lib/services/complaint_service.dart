import 'dart:convert';

import 'package:http/http.dart' as http;

class ComplaintService {

  static Future registerComplaint({
    required String complaintId,
    required String stationName,
    required String zoneName,
    required String complaintType,
    required String description,
    required String priority,
    required String engineer,
  }) async {
final url = Uri.parse(
  'http://10.11.117.141:3000/register-complaint',
);
    final response = await http.post(
      url,

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        "complaint_id": complaintId,
        "station_name": stationName,
        "zone_name": zoneName,
        "complaint_type": complaintType,
        "description": description,
        "priority": priority,
        "assigned_engineer": engineer,
      }),
    );

    return jsonDecode(response.body);
  }
}