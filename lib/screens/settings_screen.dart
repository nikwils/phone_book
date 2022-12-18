import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../providers/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

Map<String, dynamic> _packageInfo = {
  'appName': '',
  'packageName': '',
  'version': '',
  'buildNumber': '',
};

var _themeBool;
var _localActual;
var _localBool;

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Map<String, dynamic> version = {
      'appName': packageInfo.appName,
      'packageName': packageInfo.packageName,
      'version': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
    };
    setState(() {
      _packageInfo = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: false);
    var local = context.locale;
    _localBool = local == const Locale('ru') ? true : false;
    final themeBool = theme.getThemeBool();
    _themeBool = themeBool;

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: Column(
        children: [
          SwitchListTile(
            activeColor: Colors.lightGreen,
            title: Text('change_lang'.tr()),
            value: _localBool,
            onChanged: (value) async {
              _localBool
                  ? _localActual = context.supportedLocales[1]
                  : _localActual = context.supportedLocales[0];
              await context.setLocale(_localActual);
              setState(() {
                _localBool = !_localBool;
              });
            },
          ),
          SwitchListTile(
            activeColor: Colors.lightGreen,
            title:
                _themeBool ? Text('light_theme'.tr()) : Text('dark_theme'.tr()),
            value: _themeBool,
            onChanged: (value) {
              setState(
                () {
                  _themeBool = !_themeBool;
                },
              );
              theme.setMode(value);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  'version'.tr(args: [_packageInfo['version']]),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  'build_number'.tr(args: [_packageInfo['buildNumber']]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
