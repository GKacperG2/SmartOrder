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

    // Próba 2: Dopasowanie po usunięciu końcówki liczby mnogiej
    final singularOrderName = _removePluralSuffix(normalizedOrderName);
    try {
      return products.firstWhere((p) {
        final productName = _normalizeText(p.title);
        final singularProductName = _removePluralSuffix(productName);

        return singularProductName == singularOrderName || productName == singularOrderName;
      });
    } catch (e) {}

    // Próba 3: Dopasowanie zawierające (nazwa produktu zawiera się w zamówieniu lub odwrotnie)
    try {
      return products.firstWhere((p) {
        final productName = _normalizeText(p.title);
        final singularProductName = _removePluralSuffix(productName);

        return productName.contains(normalizedOrderName) ||
            normalizedOrderName.contains(productName) ||
            productName.contains(singularOrderName) ||
            singularOrderName.contains(productName) ||
            singularProductName.contains(singularOrderName) ||
            singularOrderName.contains(singularProductName);
      });
    } catch (e) {}

    // Próba 4: Dopasowanie na podstawie wszystkich znaczących słów
    final orderWords = normalizedOrderName.split(' ').where((w) => w.length > 2).toList();

    if (orderWords.isEmpty) return null;

    try {
      return products.firstWhere((p) {
        final productName = _normalizeText(p.title);
        final productWords = productName.split(' ').where((w) => w.length > 2).toList();

        if (productWords.isEmpty) return false;

        // Wszystkie słowa produktu muszą znaleźć się w zamówieniu
        int productWordsMatched = 0;
        for (var productWord in productWords) {
          final singularProductWord = _removePluralSuffix(productWord);
          for (var orderWord in orderWords) {
            final singularOrderWord = _removePluralSuffix(orderWord);
            if (singularProductWord == singularOrderWord ||
                productWord == orderWord ||
                (productWord.length > 3 && orderWord.contains(productWord)) ||
                (orderWord.length > 3 && productWord.contains(orderWord))) {
              productWordsMatched++;
              break;
            }
          }
        }

        // Wymagane dopasowanie co najmniej wszystkich słów produktu
        return productWordsMatched == productWords.length && productWords.length >= 1;
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
