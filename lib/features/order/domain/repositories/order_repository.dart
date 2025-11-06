import 'package:dartz/dartz.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/features/order/domain/entities/order_item.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderItem>>> analyzeOrderText(String text);
  Future<Either<Failure, void>> validateApiKey();
}
