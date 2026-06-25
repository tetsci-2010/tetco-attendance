class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    this.location,
    this.supervisor,
    this.description,
    this.isActive = true,
    this.employeeIds = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? location;
  final String? supervisor;
  final String? description;
  final bool isActive;
  final List<String> employeeIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  int get employeeCount => employeeIds.length;

  ProjectModel copyWith({
    String? id,
    String? name,
    String? location,
    String? supervisor,
    String? description,
    bool? isActive,
    List<String>? employeeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      supervisor: supervisor ?? this.supervisor,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      employeeIds: employeeIds ?? this.employeeIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'supervisor': supervisor,
      'description': description,
      'is_active': isActive,
      'employee_ids': employeeIds,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'],
      supervisor: json['supervisor'],
      description: json['description'],
      isActive: json['is_active'] ?? true,
      employeeIds: List<String>.from(json['employee_ids'] ?? []),
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
    );
  }
}
