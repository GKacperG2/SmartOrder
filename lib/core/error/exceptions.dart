class ServerException implements Exception {}

class CacheException implements Exception {}

class AiException implements Exception {
  final String message;

  AiException(this.message);
}
