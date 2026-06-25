import 'package:flutter/material.dart';
import 'package:tetco_attendance/features/screens/main_screens/projects_screen/data/models/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  final Map<String, ProjectModel> _projects = {};
  final List<String> _projectOrder = [];

  List<ProjectModel> get projects {
    return _projectOrder.map((id) => _projects[id]!).toList();
  }

  List<ProjectModel> get activeProjects {
    return projects.where((project) => project.isActive).toList();
  }

  int get activeProjectCount => activeProjects.length;

  int get assignedEmployeeCount {
    return projects.expand((project) => project.employeeIds).toSet().length;
  }

  void createProject({
    required String name,
    String? location,
    String? supervisor,
    String? description,
  }) {
    final now = DateTime.now();
    final project = ProjectModel(
      id: now.microsecondsSinceEpoch.toString(),
      name: name.trim(),
      location: _clean(location),
      supervisor: _clean(supervisor),
      description: _clean(description),
      createdAt: now,
      updatedAt: now,
    );

    _projects[project.id] = project;
    _projectOrder.insert(0, project.id);
    notifyListeners();
  }

  void updateProject(ProjectModel project) {
    if (!_projects.containsKey(project.id)) return;

    _projects[project.id] = project.copyWith(updatedAt: DateTime.now());
    notifyListeners();
  }

  void toggleProjectStatus(String projectId) {
    final project = _projects[projectId];
    if (project == null) return;

    updateProject(project.copyWith(isActive: !project.isActive));
  }

  void toggleEmployeeAssignment({
    required String projectId,
    required String employeeId,
  }) {
    final project = _projects[projectId];
    if (project == null) return;

    final employees = [...project.employeeIds];
    if (employees.contains(employeeId)) {
      employees.remove(employeeId);
    } else {
      employees.add(employeeId);
    }

    updateProject(project.copyWith(employeeIds: employees));
  }

  void removeProject(String projectId) {
    _projects.remove(projectId);
    _projectOrder.remove(projectId);
    notifyListeners();
  }

  String? _clean(String? value) {
    final cleaned = value?.trim();
    if (cleaned == null || cleaned.isEmpty) return null;
    return cleaned;
  }
}
