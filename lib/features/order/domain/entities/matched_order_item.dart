import 'package:equatable/equatable.dart';
import 'package:smartorder/features/products/domain/entities/product.dart';

enum MatchStatus { matched, unmatched }

class MatchedOrderItem extends Equatable {
  final Product? product;
  final String name;
  final int quantity;
  final MatchStatus status;

  const MatchedOrderItem({
    this.product,
    required this.name,
    required this.quantity,
    required this.status,
  });

  @override
  List<Object?> get props => [product, name, quantity, status];

  Map<String, dynamic> toJson() {
    return {
      'product': product?.toJson(),
      'name': name,
      'quantity': quantity,
      'status': status.toString(),
    };
  }
}
