import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvUtils {
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

  static String get(String key) {
    return dotenv.env[key] ?? '';
  }
}
