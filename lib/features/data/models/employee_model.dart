class EmployeeModel {
  final int id;
  final String name;
  final String fName;
  final String? nickName;
  final String? phone;
  final String? image;
  final String? description;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.fName,
    this.nickName,
    this.phone,
    this.image,
    this.description,
  });
}
