class EmployeeCreateModel {
  final String id;
  final String name;
  final String fName;
  final int? statusId;
  final String? nickName;
  final String? phone;
  final String? image;
  final String? description;
  final int? imageHolderColor;
  final int roleId;
  final List<int>? projectIDs;
  final String? createdAt;
  final String? updatedAt;

  const EmployeeCreateModel({
    required this.id,
    required this.name,
    required this.fName,
    this.statusId,
    this.nickName,
    this.phone,
    this.image,
    this.description,
    this.imageHolderColor,
    required this.roleId,
    this.projectIDs,
    this.createdAt,
    this.updatedAt,
  });
}
