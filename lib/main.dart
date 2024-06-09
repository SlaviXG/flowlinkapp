import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flowlinkapp/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Construct the file path for the .env file in the new location
  String envFilePath = path.join(Directory.current.path, '.env');

  // Debug: Print the current directory and file path
  print('Current directory: ${Directory.current.path}');
  print('Attempting to load .env file from: $envFilePath');

  // Check if the file exists
  if (File(envFilePath).existsSync()) {
    print('.env file found at $envFilePath');
    // Load the .env file
    try {
      await dotenv.load(fileName: envFilePath);
      print('.env file loaded successfully');
    } catch (e) {
      print('Failed to load .env file: $e');
    }
  } else {
    print('Error: .env file not found at $envFilePath');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlowLink',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
