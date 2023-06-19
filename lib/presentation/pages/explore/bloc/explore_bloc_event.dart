// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'explore_bloc_bloc.dart';

@immutable
abstract class ExplorEvent {}

class ExploreInitialEvent extends ExplorEvent {}

class PostingPostEvent extends ExplorEvent {
  final Post post;
  final File? image;
   PostingPostEvent({
    required this.post,
    required this.image,
  });
}

class PostingPostSuccessEvent extends ExplorEvent {}

class PostingPostFailedEvent extends ExplorEvent {}
class NavigateToNewPostScreenEvent extends ExplorEvent {}