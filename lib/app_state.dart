import 'package:flutter/material.dart';
import 'package:flowlinkapp/services/google_auth_service.dart';

class AppState extends ChangeNotifier {
  final Map<String, dynamic> config;
  final GoogleAuthService googleAuthService;

  AppState({required this.config, required this.googleAuthService});
}
