import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/source/local_ihome_data_source.dart';

abstract class LocalIHomeRepository extends LocalIHomeDataSource {
  static LocalHomeRepositoryImp localHomeRepositoryImp = LocalHomeRepositoryImp(localHomeDataSourceImp: LocalHomeDataSourceImp());
}

class LocalHomeRepositoryImp implements LocalIHomeRepository {
  final LocalHomeDataSourceImp localHomeDataSourceImp;

  const LocalHomeRepositoryImp({required this.localHomeDataSourceImp});
}
