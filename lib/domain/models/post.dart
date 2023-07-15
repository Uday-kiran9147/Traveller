// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comment {
  final String id;
  final String username;
  final String comment;
  final String userID;
  final String date;
  final String postID;
  const Comment({
    required this.id,
    required this.username,
    required this.comment,
    required this.userID,
    required this.date,
    required this.postID,
  });
}

class Post {
  final String id;
  final String username;
  final String imageURL;
  final String? description;
  final String userID;
  final int popularity;
  final String? location;
  final String date;
  List<Comment> comments = [];

   Post({
    required this.id,
    required this.username,
    required this.popularity,
    required this.imageURL,
    required this.description,
    required this.userID,
    required this.location,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'popularity':popularity,
      'imageURL': imageURL,
      'description': description,
      'userid': userID,
      'location': location,
      'date': date,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map["id"],
      username: map["username"] ,
      popularity: map['popularity'],
      imageURL: (map["imageURL"] ?? '') ,
      description: map["description"] ?? ' ',
      userID: map["userid"],
      location:  map["location"] ?? ' ',
      date: map["date"],
    );
  }
}
