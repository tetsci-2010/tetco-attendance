import 'package:tetco_attendance/features/screens/main_screens/employee_screen/data/source/local_iemployee_data_source.dart';

abstract class LocalIEmployeeRepository extends LocalIEmployeeDataSource {
  static final LocalEmployeeRepositoryImp localEmployeeRepositoryImp = LocalEmployeeRepositoryImp(
    localEmployeeDataSourceImp: LocalEmployeeDataSourceImp(),
  );
}

class LocalEmployeeRepositoryImp implements LocalIEmployeeRepository {
  final LocalEmployeeDataSourceImp localEmployeeDataSourceImp;

  const LocalEmployeeRepositoryImp({required this.localEmployeeDataSourceImp});
}
