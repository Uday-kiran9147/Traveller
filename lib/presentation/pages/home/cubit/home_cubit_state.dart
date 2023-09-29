// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

part of 'home_cubit_cubit.dart';

abstract class HomeCubitState extends Equatable {
  UserRegister? _user = UserRegister(
      username: '',
      email: '',
      password: '',
      upcomingtrips: [],
      uid: '',
      reputation: 0,
      followers: [],
      following: []);

  Future<UserRegister> getuser() async {
    UserRegister getuser = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => UserRegister.fromMap(value));
    _user = getuser;
    return getuser;
  }

  UserRegister get user => _user!;
  @override
  List<Object?> get props => [
        this.user.username,
        this.user.email,
        this.user.password,
        this.user.uid,
        this.user.upcomingtrips,
        this.user.followers,
        this.user.following,
        this.user.reputation
      ];
}

class HomeCubitInitial extends HomeCubitState {}

class HomeLoadedState extends HomeCubitState {
  final UserRegister user;
   HomeLoadedState({
    required this.user,
  });
  
}
