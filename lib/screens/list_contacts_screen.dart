import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/widgets/list_contacts.dart';
import 'package:easy_localization/easy_localization.dart';

import 'settings_screen.dart';

class ListContactsScreen extends StatefulWidget {
  const ListContactsScreen({super.key});

  @override
  State<ListContactsScreen> createState() => _ListContactsScreenState();
}

class _ListContactsScreenState extends State<ListContactsScreen> {
  @override
  Widget build(BuildContext context) {
    final cupertinoAppBar = CupertinoNavigationBar(
      middle: Text('title'.tr()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.settings),
            onTap: () =>
                Navigator.of(context).pushNamed(SettingsScreen.routeName),
          )
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: cupertinoAppBar,
            child: ListContacts(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('title'.tr()),
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(right: 30),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
            ),
            body: ListContacts(),
          );
  }
}
