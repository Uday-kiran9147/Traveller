import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traveler/domain/usecases/save_post.dart';

part 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit():super(ExploreInitialState());

    Future<void> postingPostEvent( {required SavePost post}) async {
        SavePost savepost = SavePost(description: post.description, location: post.location, date: post.date, image: post.image);
    bool isposted = await savepost.savepost();
      emit(PostingLoadingState());
    if (isposted) {
      emit(PostPostingSuccessState());
      emit(ExploreInitialState());
    }
    else{
      emit(PostPostingFailedState());
    }
  }

   Future<void> exploreInitialEvent() async {
    emit(ExploreInitialState());
  }

  Future<void> navigateToNewPostScreenEvent()async {
    emit(NavigateToNewPostScreenActionState());
  }

}
