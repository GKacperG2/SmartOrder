import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure([this.message = 'Błąd serwera. Sprawdź klucz API.']);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure([this.message = 'Błąd lokalnej pamięci podręcznej']);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure([this.message = 'Brak połączenia z internetem']);

  @override
  List<Object> get props => [message];
}

class AiFailure extends Failure {
  final String message;

  const AiFailure(this.message);

  @override
  List<Object> get props => [message];
}
