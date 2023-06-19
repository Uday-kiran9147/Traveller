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
  final String? location;
  final String date;
  List<Comment> comments = [];

   Post({
    required this.id,
    required this.username,
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
      'imageURL': imageURL,
      'description': description,
      'userID': userID,
      'location': location,
      'date': date,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: (map["id"] ?? '') as String,
      username: (map["username"] ?? '') as String,
      imageURL: (map["imageURL"] ?? '') as String,
      description: map['description'] != null ? map["description"] ?? '' as String : null,
      userID: (map["userID"] ?? '') as String,
      location: map['location'] != null ? map["location"] ?? '' as String : null,
      date: (map["date"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);
}
