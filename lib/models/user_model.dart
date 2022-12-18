import 'package:flutter/material.dart';

class UserModel {
  final String title;
  final String firstName;
  final String lastName;
  final String phone;
  final String id;
  final String picture;
  bool messageSent;

  UserModel(
      {required this.title,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.id,
      required this.picture,
      required this.messageSent});
}
