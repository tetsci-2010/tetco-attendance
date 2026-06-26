import 'package:tetco_attendance/features/data/source/online_data_data_source/online_idata_data_source.dart';

final onlineDataSourceImp = OnlineIDataRepositoryImp(onlineIDataDataSource: OnlineDataSourceImp());

abstract class OnlineIDataRepository extends OnlineIDataDataSource {}

final class OnlineIDataRepositoryImp implements OnlineIDataRepository {
  final OnlineDataSourceImp onlineIDataDataSource;
  OnlineIDataRepositoryImp({required this.onlineIDataDataSource});
}
