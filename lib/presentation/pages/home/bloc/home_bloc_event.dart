part of 'home_bloc_bloc.dart';

@immutable
abstract class HomeBlocEvent {}

class HomeInitialEvent extends HomeBlocEvent {}

class NavigateToExploreEvent extends HomeBlocEvent {}
