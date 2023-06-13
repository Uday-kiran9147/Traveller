import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'explore_bloc_event.dart';
part 'explore_bloc_state.dart';

class ExploreBloc extends Bloc<ExplorEvent, ExploreState> {
  ExploreBloc() : super(ExploreBlocInitial()) {
    on<ExplorEvent>((event, emit) {
      
    });
  }
}
