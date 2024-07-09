import 'package:flowlinkapp/models/handlers/event_handler.dart';
import 'package:flowlinkapp/models/handlers/note_handler.dart';
import 'package:flowlinkapp/services/gemini_service.dart';
import 'dart:convert';

class DataProcessor {
  late final Map <String, dynamic> _config;
  late GeminiService _geminiService;
  late EventHandler _eventHandler;
  late NoteHandler _noteHandler;

  DataProcessor(Map <String, dynamic> config) {
    _config = config;
    _geminiService = GeminiService(_config['gemini_api_key'], _config['system_prompt']);
    _eventHandler = EventHandler();
    _noteHandler = NoteHandler();
    _eventHandler.setNext(_noteHandler);
  }

  Future<Map <String, dynamic>> extract(String textForExtraction) async {
    final String responseText = await _geminiService.generateContent(textForExtraction);
    Map <String, dynamic> response = Map();
    try {
      response = json.decode(responseText);
    } catch (e) {
      print('Failed to decode JSON: $e');
    }
    return response;
  }

  void submit(Map<String, dynamic> data) {
    _eventHandler.handle(data);
  }
}