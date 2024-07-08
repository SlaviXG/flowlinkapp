import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late GenerativeModel model;

  GeminiService(String apiKey, String systemPrompt) {
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey, systemInstruction: Content.text(systemPrompt));
  }

  Future<String> generateContent(String textForExtraction) async {
    final content = [Content.text(ExecutionPrompt(textForExtraction: textForExtraction).toString())];
    final response = await model.generateContent(content);
    return response.text ?? 'No response text available';
  }
}

class ExecutionPrompt {
  late final Map<String, dynamic> currentDateAndTime;
  final String textForExtraction;
  final String? metadata;

  ExecutionPrompt({
    required this.textForExtraction,
    this.metadata,
  }) {
    currentDateAndTime = _getCurrentDateAndTime();
  }

  Map<String, dynamic> toJson() {
    return {
      'current_date_and_time': currentDateAndTime,
      'text_for_extraction': textForExtraction,
      'metadata': metadata,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
  
  Map<String, dynamic> _getCurrentDateAndTime() {
    DateTime now = DateTime.now();
    return {
      'year': now.year,
      'month': now.month,
      'day': now.day,
      'hour': now.hour,
      'minute': now.minute,
      'second': now.second,
    };
  }
}