// import 'dart:async';
// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
// import 'package:traveler/domain/usecases/save_post.dart';
// part 'explore_bloc_event.dart';
// part 'explore_bloc_state.dart';

// class ExploreBloc extends Bloc<ExplorEvent, ExploreState> {
//   ExploreBloc() : super(ExploreInitialState()) {
//     on<ExploreInitialEvent>(exploreInitialEvent);
//     on<NavigateToNewPostScreenEvent>(navigateToNewPostScreenEvent);
//     on<PostingPostEvent>(postingPostEvent);
//   }

//   FutureOr<void> postingPostEvent(
//       PostingPostEvent event, Emitter<ExploreState> emit) async {
//         SavePost savepost = SavePost(description: event.description, location: event.location, date: event.date, image: event.image);
//     bool isposted = await savepost.savepost();
//     if (isposted) {
//       emit(PostPostingSuccessState());
//       // Navigator.pop(context);
//     }
//     else{
//       emit(PostPostingFailedState());
//     }
//   }

//   FutureOr<void> exploreInitialEvent(
//       ExploreInitialEvent event, Emitter<ExploreState> emit) {
//     emit(ExploreInitialState());
//   }

//   FutureOr<void> navigateToNewPostScreenEvent(NavigateToNewPostScreenEvent event, Emitter<ExploreState> emit) {
//     emit(NavigateToNewPostScreenActionState());
//     print('object bloc');
//   }
// }
