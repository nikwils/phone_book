import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_book/models/user_model.dart';
import 'package:phone_book/providers/users.dart';
import 'package:provider/provider.dart';

import '../screens/contact_detail_screen.dart';
import '../services/local_notifications.dart';

class User extends StatelessWidget {
  final UserModel selectedUser;

  const User(this.selectedUser, {super.key});
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<Users>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(color: Colors.grey),
      child: Column(
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: CachedNetworkImageProvider(selectedUser.picture),
                // image: NetworkImage(selectedUser.picture),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'first_name'.tr(args: [selectedUser.firstName]),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 15),
                Text(
                  'last_name'.tr(args: [selectedUser.lastName]),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 15),
                Text(
                  'id_user'.tr(args: [selectedUser.id]),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 15),
                Text(
                  'phone'.tr(args: [selectedUser.phone]),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Platform.isIOS
                    ? CupertinoButton(
                        child: Text('call'.tr(),
                            style: Theme.of(context).textTheme.bodyLarge),
                        onPressed: () {
                          makePhoneCall(selectedUser.phone);
                        },
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          makePhoneCall(selectedUser.phone);
                        },
                        child: Text('call'.tr(),
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                const SizedBox(
                  height: 15,
                ),
                Platform.isIOS
                    ? CupertinoButton(
                        child: Text('sms'.tr(),
                            style: Theme.of(context).textTheme.bodyLarge),
                        onPressed: () {
                          Noti.showBigTextNotification(
                            title: 'user'.tr(args: [
                              selectedUser.lastName,
                              selectedUser.firstName
                            ]),
                            body: 'message'.tr(),
                            fln: flutterLocalNotificationsPlugin,
                          );
                          users.updateUser(selectedUser.id);
                        },
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Noti.showBigTextNotification(
                            title: 'user'.tr(args: [
                              selectedUser.lastName,
                              selectedUser.firstName
                            ]),
                            body: 'message'.tr(),
                            fln: flutterLocalNotificationsPlugin,
                          );
                          users.updateUser(selectedUser.id);
                        },
                        child: Text('sms'.tr(),
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
