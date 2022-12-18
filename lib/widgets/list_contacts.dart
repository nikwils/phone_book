import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users.dart';
import '../screens/contact_detail_screen.dart';

class ListContacts extends StatefulWidget {
  const ListContacts({super.key});

  @override
  State<ListContacts> createState() => _ListContactsState();
}

class _ListContactsState extends State<ListContacts> {
  late Future _ordersFuture;
  final controller = ScrollController();

  Future _obtainOrdersFuture([addPage = false]) async {
    return Provider.of<Users>(context, listen: false).fetchAndSetUsers(addPage);
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    controller.addListener(() {
      controller.position.maxScrollExtent == controller.offset
          ? _obtainOrdersFuture(true)
          : null;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _ordersFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (dataSnapshot.error != null) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return Consumer<Users>(builder: (ctx, userData, _) {
              return ListView.builder(
                itemCount: userData.items.length + 1,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= userData.items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ContactDetailScreen.routeName,
                          arguments: userData.items[index].id,
                        );
                        print('detail ${userData.items[index].id}');
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            8,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    userData.items[index].picture)
                                // NetworkImage(userData.items[index].picture),
                                ),
                            title: Text(
                              '${userData.items[index].lastName} ${userData.items[index].firstName}',
                            ),
                            subtitle: Text(
                              userData.items[index].id.toString(),
                            ),
                            trailing: userData.items[index].messageSent
                                ? const Icon(Icons.message,
                                    color: Colors.lightGreen)
                                : const Icon(Icons.message),
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            });
          }
        }
      },
    );
    ;
  }
}
