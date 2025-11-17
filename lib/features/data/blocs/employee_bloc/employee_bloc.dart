import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/data/models/employee_model.dart';
import 'package:tetco_attendance/features/data/services/employee_service.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeService employeeService;
  EmployeeBloc(this.employeeService) : super(AddEmployeeInitial()) {
    on<CreateEmployee>(_onCreateEmployee);
    on<FetchAllEmployees>(_onFetchAllEmployees);
  }
  _onCreateEmployee(CreateEmployee event, Emitter<EmployeeState> emit) async {
    try {
      emit(AddingEmployee());
      final result = await employeeService.createEmployee(event.employeeModel);
      emit(AddEmployeeSuccess(employee: result));
    } on AppException catch (e) {
      emit(AddEmployeeFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(AddEmployeeFailure(errorMessage: e.toString()));
    }
  }

  _onFetchAllEmployees(FetchAllEmployees event, Emitter<EmployeeState> emit) async {
    try {
      emit(FetchingAllEmployees());
      final result = await employeeService.fetchAllEmployees();
      emit(FetchAllEmployeesSuccess(employees: result));
    } on AppException catch (e) {
      emit(FetchAllEmployeesFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(FetchAllEmployeesFailure(errorMessage: e.toString()));
    }
  }
}
