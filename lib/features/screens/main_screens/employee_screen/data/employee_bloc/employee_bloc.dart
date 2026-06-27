import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_create_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/models/employee_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/service/employee_service.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  static QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;
  final EmployeeService employeeService;
  static bool hasMore = true;
  static bool isLoading = false;
  EmployeeBloc(this.employeeService) : super(AddEmployeeInitial()) {
    on<CreateEmployee>(_onCreateEmployee);
    on<FetchAllEmployees>(_onFetchAllEmployees);
  }
  _onCreateEmployee(CreateEmployee event, Emitter<EmployeeState> emit) async {
    try {
      emit(AddingEmployee());
      final result = await employeeService.createEmployee(event.employeeModel);
      add(FetchAllEmployees(hideLoading: true));
      emit(AddEmployeeSuccess(message: result));
    } on AppException catch (e) {
      emit(AddEmployeeFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(AddEmployeeFailure(errorMessage: e.toString()));
    }
  }

  _onFetchAllEmployees(FetchAllEmployees event, Emitter<EmployeeState> emit) async {
    try {
      if (!event.hideLoading) {
        isLoading = true;
        emit(FetchingAllEmployees());
      }
      final result = await employeeService.fetchEmployees(
        isRefresh: event.isRefresh,
        searchKey: event.searchKey,
        status: event.status,
        lastDoc: lastDoc,
      );
      lastDoc = result.lastDoc;
      if (result.items.isEmpty) {
        hasMore = false;
      } else {
        hasMore = true;
      }
      emit(FetchAllEmployeesSuccess(employees: result.items.cast<EmployeeModel>(), hasMore: hasMore));
    } on AppException catch (e) {
      emit(FetchAllEmployeesFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(FetchAllEmployeesFailure(errorMessage: e.toString()));
    } finally {
      isLoading = false;
    }
  }
}
