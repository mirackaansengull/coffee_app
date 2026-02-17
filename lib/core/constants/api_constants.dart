import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  /// .env dosyasındaki BASE_URL (yüklü değilse localhost)
  static String get baseUrl =>
      dotenv.env['BASE_URL']?.trim() ?? 'http://localhost:8080';
}
