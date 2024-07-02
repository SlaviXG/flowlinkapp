import 'package:google_generative_ai/google_generative_ai.dart';

class ApiService {
  late GenerativeModel model;

  ApiService(String apiKey) {
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<String> generateContent(String prompt) async {
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text ?? 'No response text available';
  }
}
