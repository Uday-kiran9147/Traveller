import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traveler/domain/usecases/add_travel_list.dart';
import 'package:traveler/domain/usecases/edit_profile.dart';
import '../../../../domain/usecases/delete_travel_list.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<bool> deleteDestination(var destination) async {
    DeleteTravelListItem db = DeleteTravelListItem(destination: destination);
    return await db.deleteTravelList();
  }

  addDestinationList(String destination) async {
    AddTravelItem addTravelList = AddTravelItem(destination: destination);
    await addTravelList.addTravelList().then((value) {
      if (value) {}
    });
  }

  Future<bool> editProfile(String username, String bio, String tag) async {
    EditProfile editprofile = EditProfile(username, bio, tag);
    return await editprofile.editProfile();
  }
}
