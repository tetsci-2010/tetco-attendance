class EmployeeRole {
  final int id;
  final String role;

  const EmployeeRole({required this.id, required this.role});

  factory EmployeeRole.fromJson(Map<String, dynamic> json) {
    return EmployeeRole(id: json['id'], role: json['role']);
  }
}
