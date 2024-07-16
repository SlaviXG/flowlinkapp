import 'package:flutter/material.dart';
import 'package:flowlinkapp/home_screen.dart';
import 'package:flowlinkapp/utils/data.dart';
import 'dart:convert';
import 'dart:io';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Map<String, dynamic> mainConfig = await loadConfig('config.json');
  Map<String, dynamic> authConfig = await loadConfig('auth.json');
  Map<String, dynamic> config = mergeMaps(mainConfig, authConfig);

  await hotKeyManager.unregisterAll();
  HotKey _hotKey = HotKey(
    key: PhysicalKeyboardKey.keyQ,
    modifiers: [HotKeyModifier.alt],
    scope: HotKeyScope.system,
  );
  await hotKeyManager.register(
    _hotKey,
    keyDownHandler: (hotKey) {
      print('onKeyDown+${hotKey.toJson()}');
    },
  );
  // await hotKeyManager.unregister(_hotKey);
  // await hotKeyManager.unregisterAll();

  runApp(MyApp(config: config));
}

Future<Map<String, dynamic>> loadConfig(String configPath) async {
  String configContent = await File(configPath).readAsString();
  return json.decode(configContent);
}


class MyApp extends StatelessWidget {
  final Map<String, dynamic> config;

  MyApp({required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(config: config),
    );
  }
}
