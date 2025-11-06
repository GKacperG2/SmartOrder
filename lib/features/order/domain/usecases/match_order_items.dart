import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/core/usecases/usecase.dart';
import 'package:smartorder/features/order/domain/entities/matched_order_item.dart';
import 'package:smartorder/features/order/domain/entities/order_item.dart';
import 'package:smartorder/features/products/domain/entities/product.dart';

class MatchOrderItems implements UseCase<List<MatchedOrderItem>, MatchOrderParams> {
  @override
  Future<Either<Failure, List<MatchedOrderItem>>> call(MatchOrderParams params) async {
    final matchedItems = <MatchedOrderItem>[];
    for (var orderItem in params.orderItems) {
      Product? foundProduct;
      try {
        foundProduct = params.products.firstWhere(
          (p) => p.title.toLowerCase().contains(orderItem.name.toLowerCase()),
        );
      } catch (e) {
        foundProduct = null;
      }

      if (foundProduct != null) {
        matchedItems.add(
          MatchedOrderItem(
            product: foundProduct,
            name: orderItem.name,
            quantity: orderItem.quantity,
            status: MatchStatus.matched,
          ),
        );
      } else {
        matchedItems.add(
          MatchedOrderItem(
            name: orderItem.name,
            quantity: orderItem.quantity,
            status: MatchStatus.unmatched,
          ),
        );
      }
    }
    return Right(matchedItems);
  }
}

class MatchOrderParams extends Equatable {
  final List<OrderItem> orderItems;
  final List<Product> products;

  const MatchOrderParams({required this.orderItems, required this.products});

  @override
  List<Object> get props => [orderItems, products];
}
