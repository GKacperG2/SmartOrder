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
      print('Trying to match: "${orderItem.name}"'); // DEBUG
      Product? foundProduct = _findMatchingProduct(orderItem.name, params.products);

      if (foundProduct != null) {
        print('  -> Matched with: "${foundProduct.title}"'); // DEBUG
        matchedItems.add(
          MatchedOrderItem(
            product: foundProduct,
            name: orderItem.name,
            quantity: orderItem.quantity,
            status: MatchStatus.matched,
          ),
        );
      } else {
        print('  -> NOT MATCHED'); // DEBUG
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

  Product? _findMatchingProduct(String orderItemName, List<Product> products) {
    final normalizedOrderName = _normalizeText(orderItemName);

    // Szukaj DOKŁADNEGO dopasowania (case-insensitive)
    for (var product in products) {
      if (_normalizeText(product.title) == normalizedOrderName) {
        return product;
      }
    }

    // Jeśli nie znaleziono dokładnego, spróbuj z usuniętą liczbą mnogą
    final singularOrderName = _removePluralSuffix(normalizedOrderName);
    for (var product in products) {
      final singularProductName = _removePluralSuffix(_normalizeText(product.title));
      if (singularProductName == singularOrderName) {
        return product;
      }
    }

    // Nic nie pasuje - zwróć null
    return null;
  }

  String _normalizeText(String text) {
    return text.toLowerCase().trim();
  }

  String _removePluralSuffix(String text) {
    // Usuń typowe końcówki liczby mnogiej w języku angielskim
    if (text.endsWith('ies')) {
      return '${text.substring(0, text.length - 3)}y';
    }
    if (text.endsWith('es')) {
      return text.substring(0, text.length - 2);
    }
    if (text.endsWith('s') && text.length > 1) {
      return text.substring(0, text.length - 1);
    }
    return text;
  }
}

class MatchOrderParams extends Equatable {
  final List<OrderItem> orderItems;
  final List<Product> products;

  const MatchOrderParams({required this.orderItems, required this.products});

  @override
  List<Object> get props => [orderItems, products];
}
