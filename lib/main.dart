import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import 'providers/users.dart';
import 'providers/theme_manager.dart';

import 'screens/contact_detail_screen.dart';
import 'screens/list_contacts_screen.dart';
import 'screens/settings_screen.dart';
import 'dart:async';

import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //только книжная ориентация
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initUniLinks() async {
    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      if (link != null) {
        var uri = Uri.parse(link);
        if (uri.queryParameters['id'] != null) {
          final key = uri.queryParameters['id'].toString();
          navigatorKey.currentState?.pushNamed(
            ContactDetailScreen.routeName,
            arguments: key,
          );
        }
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Users(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeNotifier(),
        )
      ],
      child: Consumer<ThemeNotifier>(builder: (ctx, theme, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'dme PhoneBook',
          theme: theme.getTheme(),
          home: ListContactsScreen(),
          routes: {
            ContactDetailScreen.routeName: ((ctx) => ContactDetailScreen()),
            SettingsScreen.routeName: ((ctx) => SettingsScreen()),
          },
        );
      }),
    );
  }
}
