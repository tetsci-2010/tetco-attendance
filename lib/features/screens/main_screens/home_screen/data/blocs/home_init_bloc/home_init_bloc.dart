import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tetco_attendance/constants/exceptions.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/models/home_initial_model.dart';
import 'package:tetco_attendance/features/screens/main_screens/home_screen/data/service/home_service.dart';

part 'home_init_event.dart';
part 'home_init_state.dart';

class HomeInitBloc extends Bloc<HomeInitEvent, HomeInitState> {
  final HomeService homeService;
  HomeInitBloc(this.homeService) : super(HomeInitInitial()) {
    on<InitializeHome>(_onInitializeHome);
  }

  _onInitializeHome(InitializeHome event, Emitter<HomeInitState> emit) async {
    try {
      emit(HomeLoading());
      final result = await homeService.initializeHome();
      emit(HomeSuccess(homeInitialModel: result));
    } on AppException catch (e) {
      emit(HomeFailure(errorMessage: e.errorMessage, statusCode: e.statusCode));
    } catch (e) {
      emit(HomeFailure(errorMessage: e.toString()));
    }
  }
}
