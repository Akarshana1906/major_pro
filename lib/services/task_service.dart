import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {

  // =========================
  // BASE URL
  // =========================
  static const String baseUrl =
      "http://10.11.117.141:3000";

  // =========================
  // REGISTER TASK
  // =========================
  static Future registerTask({
    required String taskId,
    required String stationName,
    required String zoneName,
    required String taskType,
    required String description,
    required String priority,
    required String engineer,
  }) async {

    try {

      final url = Uri.parse(
        '$baseUrl/register-task',
      );

      final response = await http.post(
        url,

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode({

          "task_id": taskId,

          "station_name": stationName,

          "zone_name": zoneName,

          "task_type": taskType,

          "description": description,

          "priority": priority,

          "assigned_engineer": engineer,
        }),
      );

      print("REGISTER STATUS : ${response.statusCode}");
      print("REGISTER BODY : ${response.body}");

      return jsonDecode(response.body);

    } catch (e) {

      print("REGISTER TASK ERROR : $e");

      throw Exception(
        "Failed to register task",
      );
    }
  }

  // =========================
  // GET ALL TASKS
  // =========================
  static Future<List<dynamic>>
      getAllTasks() async {

    try {

      final url = Uri.parse(
        '$baseUrl/tasks-register',
      );

      final response =
          await http.get(url);

      print(
        "GET TASK STATUS : ${response.statusCode}",
      );

      print(
        "GET TASK BODY : ${response.body}",
      );

      if (response.statusCode == 200) {

        return jsonDecode(response.body);

      } else {

        throw Exception(
          "Failed to load tasks",
        );
      }

    } catch (e) {

      print("GET TASK ERROR : $e");

      throw Exception(
        "Unable to fetch tasks",
      );
    }
  }

  // =========================
  // REASSIGN TASK
  // =========================
  static Future reassignTask({
    required int id,
    required String engineer,
  }) async {

    try {

      final url = Uri.parse(
        '$baseUrl/reassign-task-register/$id',
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

      print(
        "REASSIGN STATUS : ${response.statusCode}",
      );

      print(
        "REASSIGN BODY : ${response.body}",
      );

      return jsonDecode(response.body);

    } catch (e) {

      print("REASSIGN ERROR : $e");

      throw Exception(
        "Failed to reassign task",
      );
    }
  }

  // =========================
  // UPDATE TASK STATUS
  // =========================
  static Future updateTaskStatus({
    required int id,
    required String status,
  }) async {

    try {

      final url = Uri.parse(
        '$baseUrl/update-task-status/$id',
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

      print(
        "UPDATE STATUS : ${response.statusCode}",
      );

      print(
        "UPDATE BODY : ${response.body}",
      );

      return jsonDecode(response.body);

    } catch (e) {

      print("UPDATE ERROR : $e");

      throw Exception(
        "Failed to update status",
      );
    }
  }
}