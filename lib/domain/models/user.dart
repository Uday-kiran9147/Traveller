import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Userlogin {
  final String email;
  final String password;
  const Userlogin({
    required this.email,
    required this.password,
  });
}

class UserRegister {
  final String username;
  final String email;
  final String password;
  final String? profileurl;
  final String? bio;
  final String? tag;
  final List upcomingtrips;
  final String uid;
  final int reputation;
  final List followers;
  final List following;
  UserRegister({
    required this.username,
    required this.email,
    required this.password,
    this.profileurl,
    this.tag,
    required this.upcomingtrips,
    this.bio,
    required this.uid,
    required this.reputation,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'profileurl': profileurl,
      'bio': bio,
      'tag': tag,
      'upcomingtrips': upcomingtrips,
      'uid': uid,
      'reputation': reputation,
      'followers': followers,
      'following': following,
    };
  }

  static UserRegister fromMap(DocumentSnapshot snap) {
    var map = snap.data() as Map<String, dynamic>;
    return UserRegister(
        username: map["username"],
        email: map["email"],
        password: map["password"],
        profileurl: (map["profileurl"] ?? '--No Profile Url--'),
        bio: map['bio'] ?? '--No Bio--',
        uid: map["uid"],
        tag: map['tag'] ?? "User",
        upcomingtrips: map['upcomingtrips'],
        reputation: map['reputation'],
        followers: map['followers'],
        following: map['following']);
  }
}
