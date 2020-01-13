import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String token;

  User({@required this.id, @required this.email = "email",@required this.name = 'User', @required this.token});
}
