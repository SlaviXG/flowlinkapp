import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late GenerativeModel model;

  ApiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found');
    }
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<String> generateContent(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? 'No response text available';
  }
}
