part of 'explore_cubit.dart';

class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object> get props => [];
}

abstract class ExploreInitial {}
// abstract class ExploreState {}

abstract class ExploreActionState extends ExploreState {}

class ExploreInitialState extends ExploreState {}

// class PostPostingState extends ExploreState {}

class PostPostingSuccessState extends ExploreActionState {}

class PostPostingFailedState extends ExploreActionState {}

class NavigateToNewPostScreenActionState extends ExploreActionState {}
class PostingLoadingState extends ExploreState {}