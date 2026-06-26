class HomeInitialModel {
  final int presents;
  final int absents;
  final int lates;
  final int noStatuses;
  final int totalProjects;
  final int totalEmployeesProjects;
  final int totalEmployees;

  const HomeInitialModel({
    required this.presents,
    required this.absents,
    required this.lates,
    required this.noStatuses,
    required this.totalProjects,
    required this.totalEmployeesProjects,
    required this.totalEmployees,
  });

  double get completionRate {
    if (totalEmployees == 0) return 0;
    return (presents + absents + lates) / totalEmployees;
  }
}
