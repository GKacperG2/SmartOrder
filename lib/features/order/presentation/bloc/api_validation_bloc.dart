import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/features/order/domain/usecases/validate_api_key.dart';
import 'api_validation_event.dart';
import 'api_validation_state.dart';

class ApiValidationBloc extends Bloc<ApiValidationEvent, ApiValidationState> {
  final ValidateApiKey validateApiKey;

  ApiValidationBloc({required this.validateApiKey}) : super(ApiValidationInitial()) {
    on<ValidateApiKeyEvent>((event, emit) async {
      emit(ApiValidationLoading());

      final result = await validateApiKey();

      result.fold((failure) {
        String message = 'Nieznany błąd';
        if (failure is AiFailure) {
          message = failure.message;
        } else if (failure is NetworkFailure) {
          message = failure.message;
        } else if (failure is ServerFailure) {
          message = failure.message;
        }
        emit(ApiValidationInvalid(message: message));
      }, (_) => emit(ApiValidationValid()));
    });
  }
}
