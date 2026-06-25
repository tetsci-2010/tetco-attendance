import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/data/enums/att_status_enums.dart';
import 'package:tetco_attendance/features/data/models/project_attendance_record.dart';

class ProjectAttendanceProvider extends ChangeNotifier {
  final Map<String, ProjectAttendanceRecord> _records = {};

  List<ProjectAttendanceRecord> get records => _records.values.toList()
    ..sort((first, second) {
      return (second.updatedAt ?? second.createdAt ?? DateTime(0))
          .compareTo(first.updatedAt ?? first.createdAt ?? DateTime(0));
    });

  List<ProjectAttendanceRecord> recordsForProject(String projectId) {
    return records.where((record) => record.projectId == projectId).toList();
  }

  ProjectAttendanceRecord? recordFor({
    required String projectId,
    required String employeeId,
    required String dateKey,
  }) {
    return _records[_recordKey(projectId, employeeId, dateKey)];
  }

  int completedCount({
    required String projectId,
    required String dateKey,
    required Iterable<String> employeeIds,
  }) {
    return employeeIds.where((employeeId) {
      return recordFor(projectId: projectId, employeeId: employeeId, dateKey: dateKey) != null;
    }).length;
  }

  void markAttendance({
    required String projectId,
    required String employeeId,
    required String dateKey,
    required AttStatusEnums status,
    String? note,
  }) {
    final key = _recordKey(projectId, employeeId, dateKey);
    final now = DateTime.now();
    final existing = _records[key];

    _records[key] = ProjectAttendanceRecord(
      id: key,
      projectId: projectId,
      employeeId: employeeId,
      dateKey: dateKey,
      status: status,
      note: note,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    notifyListeners();
  }

  String _recordKey(String projectId, String employeeId, String dateKey) {
    return '$projectId-$employeeId-$dateKey';
  }
}
