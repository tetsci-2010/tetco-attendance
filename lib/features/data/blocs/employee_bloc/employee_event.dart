part of 'employee_bloc.dart';

sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

final class CreateEmployee extends EmployeeEvent {
  final EmployeeModel employeeModel;

  const CreateEmployee({required this.employeeModel});

  @override
  List<Object?> get props => [employeeModel];
}

final class FetchAllEmployees extends EmployeeEvent {
  final bool isRefresh;
  final bool hideLoading;

  const FetchAllEmployees({this.isRefresh = false, this.hideLoading = false});

  @override
  List<Object?> get props => [isRefresh, hideLoading];
}
