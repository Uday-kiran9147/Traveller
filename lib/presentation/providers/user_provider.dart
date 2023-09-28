// // ignore_for_file: must_be_immutable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:traveler/domain/models/user.dart';

// class UserProvider extends Equatable {
//   UserRegister? _user = UserRegister(
//       username: '',
//       email: '',
//       password: '',
//       upcomingtrips: [],
//       uid: '',
//       reputation: 0,
//       followers: [],
//       following: []);

//   Future<UserRegister> getuser() async {
//     UserRegister getuser = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((value) => UserRegister.fromMap(value));
//     _user = getuser;
//     return getuser;
//   }

//   UserRegister get user => _user!;
//   @override
//   List<Object?> get props => [user.username, user.email, user.password, user.uid , user.upcomingtrips , user.followers , user.following , user.reputation];

// }
