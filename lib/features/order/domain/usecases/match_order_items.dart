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
      Product? foundProduct = _findMatchingProduct(orderItem.name, params.products);

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

  Product? _findMatchingProduct(String orderItemName, List<Product> products) {
    final normalizedOrderName = _normalizeText(orderItemName);

    // Próba 1: Dokładne dopasowanie
    try {
      return products.firstWhere((p) => _normalizeText(p.title) == normalizedOrderName);
    } catch (e) {}

    // Próba 2: Dopasowanie zawierające
    try {
      return products.firstWhere(
        (p) =>
            _normalizeText(p.title).contains(normalizedOrderName) ||
            normalizedOrderName.contains(_normalizeText(p.title)),
      );
    } catch (e) {}

    // Próba 3: Dopasowanie po usunięciu końcówki liczby mnogiej
    final singularOrderName = _removePluralSuffix(normalizedOrderName);
    try {
      return products.firstWhere((p) {
        final productName = _normalizeText(p.title);
        final singularProductName = _removePluralSuffix(productName);

        return singularProductName == singularOrderName ||
            productName.contains(singularOrderName) ||
            singularOrderName.contains(productName) ||
            productName.contains(singularProductName) ||
            singularProductName.contains(singularOrderName);
      });
    } catch (e) {}

    // Próba 4: Dopasowanie na podstawie słów kluczowych
    final orderWords = normalizedOrderName.split(' ');
    try {
      return products.firstWhere((p) {
        final productName = _normalizeText(p.title);
        final productWords = productName.split(' ');

        // Sprawdź czy co najmniej 2 słowa się zgadzają lub wszystkie słowa produktu są w zamówieniu
        int matchCount = 0;
        for (var productWord in productWords) {
          if (orderWords.any(
            (orderWord) => orderWord.contains(productWord) || productWord.contains(orderWord),
          )) {
            matchCount++;
          }
        }

        return matchCount >= productWords.length || matchCount >= 2;
      });
    } catch (e) {}

    return null;
  }

  String _normalizeText(String text) {
    return text.toLowerCase().trim();
  }

  String _removePluralSuffix(String text) {
    // Usuń typowe końcówki liczby mnogiej w języku angielskim
    if (text.endsWith('ies')) {
      return text.substring(0, text.length - 3) + 'y';
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
