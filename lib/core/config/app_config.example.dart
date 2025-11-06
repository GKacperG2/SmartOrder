class AppConfig {
  static const String openRouterApiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE',
  );
}
