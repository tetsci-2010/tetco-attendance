part of 'home_init_bloc.dart';

sealed class HomeInitEvent extends Equatable {
  const HomeInitEvent();

  @override
  List<Object?> get props => [];
}

final class InitializeHome extends HomeInitEvent {}
