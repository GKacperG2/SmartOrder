# SmartOrder AI 🛒🤖

Inteligentna aplikacja mobilna Flutter do analizy zamówień tekstowych za pomocą AI i automatycznego wyliczania kosztów na podstawie bazy produktów.

## 📋 Spis treści

- [Opis projektu](#-opis-projektu)
- [Funkcjonalności](#-funkcjonalności)
- [Technologie](#-technologie)
- [Architektura](#-architektura)
- [Konfiguracja](#-konfiguracja)
- [Instalacja i uruchomienie](#-instalacja-i-uruchomienie)
- [Użytkowanie](#-użytkowanie)
- [Struktura projektu](#-struktura-projektu)

## 🎯 Opis projektu

**SmartOrder AI** to zaawansowana aplikacja mobilna stworzona w technologii Flutter, która rewolucjonizuje proces składania zamówień. Aplikacja wykorzystuje sztuczną inteligencję do analizy tekstu zamówienia, automatycznie rozpoznaje produkty i oblicza całkowity koszt na podstawie aktualnej bazy produktów.

### Główne zalety:

- ✨ Automatyczne rozpoznawanie produktów z tekstu
- 🔍 Inteligentne dopasowywanie nazw produktów (obsługa liczby mnogiej)
- 💰 Automatyczne wyliczanie kosztów
- 📊 Przejrzysty interfejs z tabelarycznym wyświetlaniem wyników
- 🔐 Walidacja klucza API przy starcie aplikacji
- 🌐 Obsługa wielu języków w analizie zamówień

## 🚀 Funkcjonalności

### Zarządzanie produktami

- 📦 Pobieranie listy produktów z API (`dummyjson.com`)
- 🔍 Wyszukiwanie produktów w czasie rzeczywistym
- 💵 Wyświetlanie cen i szczegółów produktów
- 🔄 Automatyczne odświeżanie listy
- ⚠️ Obsługa błędów z możliwością ponownej próby

### Analiza zamówień

- 📝 Wprowadzanie tekstu zamówienia (obsługa wielojęzyczna)
- 🤖 Analiza tekstu przez AI (OpenRouter API)
- 🎯 Automatyczne wyodrębnianie nazw produktów i ilości
- 🔄 Inteligentne dopasowywanie z bazą produktów
- 📊 Wyświetlanie wyników w formie tabeli
- 💾 Eksport wyniku do formatu JSON
- 🔍 Filtrowanie wyników zamówienia

### Dodatkowe funkcje

- 🔐 Automatyczna walidacja klucza API przy starcie
- ⚠️ Profesjonalna obsługa błędów z komunikatami po polsku
- 🎨 Responsywny interfejs użytkownika
- 📱 Wsparcie dla różnych rozmiarów ekranów

## 🛠 Technologie

### Framework i język

- **Flutter** 3.x - framework do tworzenia aplikacji mobilnych
- **Dart** - język programowania

### Zarządzanie stanem

- **flutter_bloc** 8.x - implementacja wzorca BLoC
- **equatable** - porównywanie obiektów

### Komunikacja sieciowa

- **dio** - zaawansowany klient HTTP
- **internet_connection_checker** - sprawdzanie połączenia internetowego

### Architektura

- **get_it** - dependency injection
- **dartz** - programowanie funkcyjne (Either, Option)

### AI

- **OpenRouter API** - dostęp do modeli AI (GPT-OSS-Safeguard-20B)

## 🏗 Architektura

Projekt wykorzystuje **Clean Architecture** z podziałem na warstwy:

```
lib/
├── core/                          # Współdzielone komponenty
│   ├── config/                    # Konfiguracja (API keys)
│   ├── error/                     # Obsługa błędów
│   ├── network/                   # Sprawdzanie połączenia
│   └── usecases/                  # Bazowe use case'y
│
├── features/                      # Funkcjonalności aplikacji
│   ├── products/                  # Moduł produktów
│   │   ├── data/                  # Warstwa danych
│   │   │   ├── datasources/       # Źródła danych (API)
│   │   │   ├── models/            # Modele danych
│   │   │   └── repositories/      # Implementacje repozytoriów
│   │   ├── domain/                # Warstwa biznesowa
│   │   │   ├── entities/          # Encje domenowe
│   │   │   ├── repositories/      # Interfejsy repozytoriów
│   │   │   └── usecases/          # Przypadki użycia
│   │   └── presentation/          # Warstwa prezentacji
│   │       ├── bloc/              # BLoC (stan aplikacji)
│   │       └── pages/             # Widoki UI
│   │
│   └── order/                     # Moduł zamówień
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── injection_container.dart       # Konfiguracja DI
└── main.dart                      # Entry point aplikacji
```

### Wzorce projektowe:

- **BLoC Pattern** - zarządzanie stanem
- **Repository Pattern** - abstrakcja źródeł danych
- **Dependency Injection** - luźne powiązania
- **Clean Architecture** - separacja warstw

## ⚙ Konfiguracja

### Krok 1: Uzyskanie klucza API

Aplikacja wymaga klucza API od **OpenRouter** do komunikacji z modelami AI:

1. Zarejestruj się na [OpenRouter.ai](https://openrouter.ai)
2. Wygeneruj klucz API w panelu użytkownika
3. Skopiuj klucz do wykorzystania w następnym kroku

### Krok 2: Konfiguracja pliku z kluczem API

1. W katalogu `lib/core/config/` znajduje się plik przykładowy `app_config.example.dart`
2. Skopiuj ten plik i nazwij go `app_config.dart`:
   ```bash
   cd lib/core/config
   copy app_config.example.dart app_config.dart
   ```
3. Otwórz plik `app_config.dart` i wklej swój klucz API:
   ```dart
   class AppConfig {
     static const String openRouterApiKey = 'TWÓJ_KLUCZ_API_TUTAJ';
   }
   ```

⚠️ **Ważne**: Plik `app_config.dart` jest w `.gitignore` i nie zostanie dodany do repozytorium, co zapewnia bezpieczeństwo klucza API.

## 📦 Instalacja i uruchomienie

### Wymagania wstępne

- **Flutter SDK** 3.0 lub nowszy
- **Dart SDK** 3.0 lub nowszy
- Emulator Android/iOS lub fizyczne urządzenie
- Połączenie z internetem

### Kroki instalacji

1. **Sklonuj repozytorium:**

   ```bash
   git clone <url_repozytorium>
   cd SmartOrder
   ```

2. **Zainstaluj zależności:**

   ```bash
   flutter pub get
   ```

3. **Skonfiguruj klucz API** (patrz sekcja [Konfiguracja](#-konfiguracja))

4. **Uruchom aplikację:**
   ```bash
   flutter run
   ```

### Uruchomienie na konkretnej platformie

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web (jeśli wspierane)
flutter run -d chrome
```

## 📱 Użytkowanie

### 1. Przeglądanie produktów

- Otwórz zakładkę **"Products"**
- Przewiń listę produktów z cenami
- Użyj pola wyszukiwania aby szybko znaleźć produkt

### 2. Analiza zamówienia

#### Krok 1: Wprowadź tekst zamówienia

Przejdź do zakładki **"Order"** i wpisz lub wklej tekst zamówienia, np.:

```
Zamawiam 10 Apple AirPods oraz 5 Essence Mascara Lash Princess
```

lub po angielsku:

```
I need 3 iPhone and 2 red lipsticks
```

#### Krok 2: Kliknij "Analizuj zamówienie"

Aplikacja prześle tekst do AI, który wyodrębni:

- Nazwy produktów
- Ilości

#### Krok 3: Przejrzyj wyniki

W tabeli zobaczysz:

- **Nazwa produktu** - dopasowany produkt z bazy
- **Ilość** - liczba sztuk
- **Cena jednostkowa** - cena za 1 szt.
- **Suma** - całkowity koszt (ilość × cena)

Niedopasowane produkty będą oznaczone jako **"Niedopasowane"**.

#### Krok 4: Eksportuj wyniki (opcjonalnie)

Kliknij **"Eksportuj do JSON"** aby zobaczyć wynik w formacie JSON.

### 3. Wyszukiwanie w wynikach

Użyj pola wyszukiwania nad tabelą wyników aby filtrować produkty.

## 📂 Struktura projektu

```
SmartOrder/
│
├── android/                    # Konfiguracja Android
├── ios/                        # Konfiguracja iOS
├── lib/                        # Kod źródłowy aplikacji
│   ├── core/                   # Rdzeń aplikacji
│   ├── features/               # Moduły funkcjonalne
│   ├── injection_container.dart
│   └── main.dart
│
├── test/                       # Testy jednostkowe
├── pubspec.yaml                # Zależności projektu
├── analysis_options.yaml       # Reguły analizy kodu
└── README.md                   # Ten plik
```

## 🔒 Bezpieczeństwo

- ✅ Klucz API jest przechowywany lokalnie w pliku ignorowanym przez Git
- ✅ Automatyczna walidacja klucza przy starcie aplikacji
- ✅ Bezpieczna komunikacja HTTPS z API
- ✅ Obsługa błędów autoryzacji (401)

## 🐛 Rozwiązywanie problemów

### Problem: "Klucz API jest pusty"

**Rozwiązanie:** Upewnij się, że utworzyłeś plik `app_config.dart` i wkleiłeś prawidłowy klucz API.

### Problem: "Nieprawidłowy klucz API"

**Rozwiązanie:** Sprawdź czy klucz API z OpenRouter jest poprawny i aktywny.

### Problem: "Brak połączenia z internetem"

**Rozwiązanie:** Sprawdź połączenie internetowe i uprawnienia aplikacji.

### Problem: Produkty nie są dopasowywane

**Rozwiązanie:** AI stara się wyodrębnić pełne nazwy produktów. Upewnij się, że tekst zamówienia zawiera wystarczające informacje.

## 👨‍💻 Autor

Projekt stworzony jako część zadania rekrutacyjnego.

## 📄 Licencja

Ten projekt jest dostępny na licencji MIT.

---

**SmartOrder AI** - Inteligentne zamówienia na wyciągnięcie ręki! 🚀
`bash
    flutter run --dart-define=OPENROUTER_API_KEY=YOUR_API_KEY
    `

## Bonus Features

- (Optional) Export order results to JSON.
- (Optional) Simple product search on the products list.
