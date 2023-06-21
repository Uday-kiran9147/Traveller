import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'home_bloc_event.dart';
part 'home_bloc_state.dart';

class HomeBlocBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  HomeBlocBloc() : super(HomeBlocInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<NavigateToExploreEvent>(navigateToExploreEvent);
  }

  FutureOr<void> navigateToExploreEvent(
      NavigateToExploreEvent event, Emitter<HomeBlocState> emit) {
    emit(NavigateToExploreActionState());
    print("navigate Explore Event");
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeBlocState> emit) async {
    emit(HomeSuccessState());
    print('homeInitialEvent');
    await Future.delayed(Duration(seconds: 5));
  }
}
