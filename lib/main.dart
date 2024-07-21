import 'package:flowlinkapp/services/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flowlinkapp/widgets/home_screen.dart';
import 'package:flowlinkapp/widgets/login_screen.dart';
import 'package:flowlinkapp/widgets/splash_screen.dart';
import 'package:flowlinkapp/utils/data.dart';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flowlinkapp/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Map<String, dynamic> mainConfig = await loadConfig('config.json');
  Map<String, dynamic> authConfig = await loadConfig('secrets.json');
  Map<String, dynamic> config = mergeMaps(mainConfig, authConfig);
  GoogleAuthService googleAuthService = GoogleAuthService(
    config['data_processor']['services']['flowlink']['client_id'],
    config['data_processor']['services']['flowlink']['client_secret'],
    config['data_processor']['services']['flowlink']['scopes'],
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(config: config, googleAuthService: googleAuthService),
      child: MyApp(),
    ),
  );
}

Future<Map<String, dynamic>> loadConfig(String configPath) async {
  String configContent = await File(configPath).readAsString();
  return json.decode(configContent);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
