import 'package:equatable/equatable.dart';

abstract class ApiValidationEvent extends Equatable {
  const ApiValidationEvent();

  @override
  List<Object> get props => [];
}

class ValidateApiKeyEvent extends ApiValidationEvent {}
