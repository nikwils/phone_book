import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../providers/users.dart';
import '../services/local_notifications.dart';
import '../widgets/user.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ContactDetailScreen extends StatefulWidget {
  static const routeName = '/contact-detail';

  const ContactDetailScreen({super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  @override
  void initState() {
    Noti.initialize(flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ModalRoute.of(context)?.settings.arguments as String;

    final selectedUser = Provider.of<Users>(
      context,
      listen: false,
    ).findById(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${selectedUser.firstName} ${selectedUser.lastName}',
        ),
      ),
      body: User(selectedUser),
    );
  }
}
