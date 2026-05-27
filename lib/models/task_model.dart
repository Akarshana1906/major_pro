// class TaskModel {
//   final int id;
//   final String title;
//   final String description;
//   final String type;
//   final String status;
//   final String assignedTo;

//   TaskModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.type,
//     required this.status,
//     required this.assignedTo,
//   });

//   factory TaskModel.fromJson(Map<String, dynamic> json) {
//     return TaskModel(
//       id: json['id'],
//       title: json['title'],
//       description: json['description'],
//       type: json['type'],
//       status: json['status'],
//       assignedTo: json['assigned_to'],
//     );
//   }
// }

class TaskModel {

  final int id;

  final String title;

  final String description;

  final String type;

  final String status;

  final String assignedTo;

  final String depot;

  TaskModel({

    required this.id,

    required this.title,

    required this.description,

    required this.type,

    required this.status,

    required this.assignedTo,

    required this.depot,
  });

  factory TaskModel.fromJson(
      Map<String, dynamic> json) {

    return TaskModel(

      id: json['id'],

      title: json['title'],

      description: json['description'],

      type: json['type'],

      status: json['status'],

      assignedTo: json['assigned_to'],

      depot: json['depot'] ?? "",
    );
  }
}