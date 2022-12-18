import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phone_book/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Users with ChangeNotifier {
  List<UserModel> _items = [];

  List<UserModel> get items {
    return [..._items];
  }

  UserModel findById(id) {
    return _items.firstWhere((user) => user.id == id);
  }

  void updateUser(id) {
    final selectedUser = _items.firstWhere((user) => user.id == id);
    selectedUser.messageSent = true;
    notifyListeners();
  }

  fetchAndSetUsers(addPage) async {
    var page = 1;
    if (addPage) {
      page++;
    }

    var url = Uri.parse(
        'https://randomuser.me/api/?results=20&inc=id,name,picture,phone&nat=in&page=$page');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);

      final List<UserModel> loadedUser = [];

      extractedData['results'].forEach((user) {
        loadedUser.add(
          UserModel(
            id: user['id']['value'],
            firstName: user['name']['first'].toString(),
            lastName: user['name']['last'].toString(),
            title: user['name']['title'].toString(),
            phone: user['phone'].toString(),
            picture: user['picture']['large'].toString(),
            messageSent: false,
          ),
        );
        CachedNetworkImage(
          imageUrl: user['picture']['large'].toString(),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );
      });

      for (var user in loadedUser) {
        _items.add(user);
      }
      notifyListeners();
    } catch (error) {
      error;
    }
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}
