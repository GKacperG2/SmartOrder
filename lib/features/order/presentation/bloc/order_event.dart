import 'package:equatable/equatable.dart';
import 'package:smartorder/features/products/domain/entities/product.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AnalyzeOrderEvent extends OrderEvent {
  final String orderText;
  final List<Product> products;

  const AnalyzeOrderEvent({required this.orderText, required this.products});

  @override
  List<Object> get props => [orderText, products];
}
