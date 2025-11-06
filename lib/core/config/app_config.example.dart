class AppConfig {
  static const String openRouterApiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE',
  );
}

// Change the name of file to app_config.dart and replace the defaultValue with your actual API key.
