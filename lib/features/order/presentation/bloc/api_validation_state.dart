import 'package:equatable/equatable.dart';

abstract class ApiValidationState extends Equatable {
  const ApiValidationState();

  @override
  List<Object> get props => [];
}

class ApiValidationInitial extends ApiValidationState {}

class ApiValidationLoading extends ApiValidationState {}

class ApiValidationValid extends ApiValidationState {}

class ApiValidationInvalid extends ApiValidationState {
  final String message;

  const ApiValidationInvalid({required this.message});

  @override
  List<Object> get props => [message];
}
