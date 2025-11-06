# Konfiguracja aplikacji

## Jak skonfigurować klucz API

1. Skopiuj plik `app_config.example.dart` i nazwij go `app_config.dart`:

   ```
   cp app_config.example.dart app_config.dart
   ```

2. Otwórz plik `app_config.dart` i zamień `'YOUR_API_KEY_HERE'` na swój prawdziwy klucz API z OpenRouter.

3. **WAŻNE**: Plik `app_config.dart` jest dodany do `.gitignore` i NIE BĘDZIE commitowany do repozytorium. To zabezpiecza Twój klucz API.

## Jak otrzymać klucz API

1. Zarejestruj się na [OpenRouter](https://openrouter.ai/)
2. Przejdź do ustawień konta i wygeneruj nowy klucz API
3. Skopiuj klucz i wklej go do pliku `app_config.dart`
