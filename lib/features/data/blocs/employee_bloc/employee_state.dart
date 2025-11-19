part of 'employee_bloc.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

final class AddEmployeeInitial extends EmployeeState {}

final class AddingEmployee extends EmployeeState {}

final class AddEmployeeSuccess extends EmployeeState {
  final EmployeeModel employee;

  const AddEmployeeSuccess({required this.employee});

  @override
  List<Object> get props => [employee];
}

final class AddEmployeeFailure extends EmployeeState {
  final String errorMessage;
  final String? statusCode;

  const AddEmployeeFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}

final class FetchingAllEmployees extends EmployeeState {}

final class FetchAllEmployeesSuccess extends EmployeeState {
  final List<EmployeeModel> employees;
  final bool hasMore;

  const FetchAllEmployeesSuccess({required this.employees, required this.hasMore});
  @override
  List<Object?> get props => [employees, hasMore];
}

final class FetchAllEmployeesFailure extends EmployeeState {
  final String errorMessage;
  final String? statusCode;

  const FetchAllEmployeesFailure({required this.errorMessage, this.statusCode});
  @override
  List<Object?> get props => [errorMessage, statusCode];
}
