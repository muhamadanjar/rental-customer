import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String token;

  User({@required this.id, this.email = "email",this.name = 'User', @required this.token});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        token: json['token']
    );
  }
}
