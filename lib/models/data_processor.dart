import 'package:flowlinkapp/models/handlers/event_handler.dart';
import 'package:flowlinkapp/models/handlers/task_handler.dart';
import 'package:flowlinkapp/services/google_auth_service.dart';
import 'package:flowlinkapp/services/gemini_service.dart';
import 'dart:convert';

class DataProcessor {
  late final Map <String, dynamic> _config;
  late GoogleAuthService _googleAuthService;
  late GeminiService _geminiService;
  late EventHandler _eventHandler;
  late TaskHandler _taskHandler;

  DataProcessor(Map <String, dynamic> config) {
    _config = config;
    _geminiService = GeminiService(_config['services']['gemini']['api_key'], _config['services']['gemini']['system_prompt']);
    _googleAuthService = GoogleAuthService(_config['services']['flowlink']['client_id'], _config['services']['flowlink']['client_secret'], _config['services']['flowlink']['scopes']);
    _eventHandler = EventHandler(_googleAuthService);
    _taskHandler = TaskHandler(_googleAuthService);
    _eventHandler.setNext(_taskHandler);
  }

  Future<Map <String, dynamic>> extract(String textForExtraction) async {
    String responseText = await _geminiService.generateContent(textForExtraction);
    Map <String, dynamic> response = Map();
    try {
      final RegExp regex = RegExp(r'^```json|```$');
      responseText = responseText.replaceAll(regex, '').trim();
      response = json.decode(responseText);
    } catch (e) {
      print('Failed to decode JSON: $e');
      print(responseText);
    }
    return response;
  }

  Future <void> submit(Map<String, dynamic> data) async {
    // Start the chain
    _eventHandler.handle(data);
  }

  GoogleAuthService getGoogleAuthService() {
    return _googleAuthService;
  }
}