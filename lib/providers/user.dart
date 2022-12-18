import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final String id;
  final String picture;
  final String title;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.picture,
    required this.title,
    required this.firstName,
    required this.lastName,
  });
}
