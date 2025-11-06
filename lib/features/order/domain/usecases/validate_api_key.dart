import 'package:dartz/dartz.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/features/order/domain/repositories/order_repository.dart';

class ValidateApiKey {
  final OrderRepository repository;

  ValidateApiKey(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.validateApiKey();
  }
}
