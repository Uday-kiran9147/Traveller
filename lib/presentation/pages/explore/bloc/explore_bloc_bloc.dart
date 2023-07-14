import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../../domain/models/post.dart';
import '../../../../domain/repositories/authentication.dart';
part 'explore_bloc_event.dart';
part 'explore_bloc_state.dart';

class ExploreBloc extends Bloc<ExplorEvent, ExploreState> {
  ExploreBloc() : super(ExploreInitialState()) {
    on<ExploreInitialEvent>(exploreInitialEvent);
    on<NavigateToNewPostScreenEvent>(navigateToNewPostScreenEvent);
    on<PostingPostEvent>(postingPostEvent);
  }

  FutureOr<void> postingPostEvent(
      PostingPostEvent event, Emitter<ExploreState> emit) async {
    bool isposted = await GoogleAuth.postUserPost(
      Post(
          id: "id",
          username: "username",
          imageURL: "imageURL",
          popularity: 0,
          description: event.post.description,
          userID: "userid",
          location: event.post.location,
          date: DateTime.now().toString()),
      event.image!,
    );
    if (isposted) {
      emit(PostPostingSuccessState());
      // Navigator.pop(context);
    }
    else{
      emit(PostPostingFailedState());
    }
  }

  FutureOr<void> exploreInitialEvent(
      ExploreInitialEvent event, Emitter<ExploreState> emit) {
    emit(ExploreInitialState());
  }

  FutureOr<void> navigateToNewPostScreenEvent(NavigateToNewPostScreenEvent event, Emitter<ExploreState> emit) {
    emit(NavigateToNewPostScreenActionState());
    print('object bloc');
  }
}
