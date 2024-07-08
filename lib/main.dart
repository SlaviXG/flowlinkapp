import 'package:flutter/material.dart';
import 'package:flowlinkapp/home_screen.dart';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, dynamic> config = await loadConfig();
  runApp(MyApp(config: config));
}

Future<Map<String, dynamic>> loadConfig() async {
  String configContent = await File('config.json').readAsString();
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
