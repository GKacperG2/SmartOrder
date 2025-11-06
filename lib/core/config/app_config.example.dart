class AppConfig {
  // INSTRUKCJA:
  // 1. Skopiuj ten plik jako 'app_config.dart' w tym samym folderze
  // 2. Zamień 'YOUR_API_KEY_HERE' na swój prawdziwy klucz API z OpenRouter
  // 3. NIE commituj pliku app_config.dart do repozytorium!

  static const String openRouterApiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE',
  );
}
