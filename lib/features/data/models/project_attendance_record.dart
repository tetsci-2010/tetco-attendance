import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';

class ProjectAttendanceRecord {
  const ProjectAttendanceRecord({
    required this.id,
    required this.projectId,
    required this.employeeId,
    required this.dateKey,
    required this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String projectId;
  final String employeeId;
  final String dateKey;
  final AttStatusEnums status;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProjectAttendanceRecord copyWith({
    String? id,
    String? projectId,
    String? employeeId,
    String? dateKey,
    AttStatusEnums? status,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectAttendanceRecord(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      employeeId: employeeId ?? this.employeeId,
      dateKey: dateKey ?? this.dateKey,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
