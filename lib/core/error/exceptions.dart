class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Błąd serwera']);
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Błąd cache']);
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Brak połączenia z internetem']);
}

class AiException implements Exception {
  final String message;

  AiException(this.message);
}
