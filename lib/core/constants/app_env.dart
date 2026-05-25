import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static String get googleClientId =>
      dotenv.env['GOOGLE_CLIENT_ID'] ?? '';

  static String get tmdbToken =>
      dotenv.env['TMDB_TOKEN'] ?? '';

  static String get rawgKey =>
      dotenv.env['RAWG_KEY'] ?? '';
}
