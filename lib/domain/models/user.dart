import 'dart:convert';

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
  final String userName;
  final String email;
  final String password;
  const UserRegister({
    required this.userName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'password': password,
    };
  }

  factory UserRegister.fromMap(Map<String, dynamic> map) {
    return UserRegister(
      userName: (map["userName"] ?? '') as String,
      email: (map["email"] ?? '') as String,
      password: (map["password"] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRegister.fromJson(String source) => UserRegister.fromMap(json.decode(source) as Map<String, dynamic>);
}

