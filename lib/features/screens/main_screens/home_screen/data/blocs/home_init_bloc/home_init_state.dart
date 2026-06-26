part of 'home_init_bloc.dart';

sealed class HomeInitState extends Equatable {
  const HomeInitState();

  @override
  List<Object?> get props => [];
}

final class HomeInitInitial extends HomeInitState {}

final class HomeLoading extends HomeInitState {}

final class HomeSuccess extends HomeInitState {
  final HomeInitialModel homeInitialModel;

  const HomeSuccess({required this.homeInitialModel});

  @override
  List<Object?> get props => [homeInitialModel];
}

final class HomeFailure extends HomeInitState {
  final String errorMessage;
  final String? statusCode;

  const HomeFailure({required this.errorMessage, this.statusCode});

  @override
  List<Object?> get props => [errorMessage, statusCode];
}
