class EngineerModel {

  final int id;
  final String name;
  final String empId;
  final String phone;
  final double latitude;
  final double longitude;

  EngineerModel({
    required this.id,
    required this.name,
    required this.empId,
    required this.phone,
    required this.latitude,
    required this.longitude,
  });

  factory EngineerModel.fromJson(Map<String, dynamic> json) {

    return EngineerModel(
      id: json['id'],
      name: json['name'],
      empId: json['emp_id'],
      phone: json['phone'],
      latitude:
          double.parse(json['latitude'].toString()),
      longitude:
          double.parse(json['longitude'].toString()),
    );
  }
}