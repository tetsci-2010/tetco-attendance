import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tetco_attendance/features/data/enums/language.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationInitial()) {
    on<ChangeLanguage>(_onChangeLanguage);
  }

  _onChangeLanguage(ChangeLanguage event, Emitter<LocalizationState> emit) async {
    emit(state.copyWith(selectedLanguage: event.language));
  }
}
