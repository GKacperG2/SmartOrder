import 'package:equatable/equatable.dart';
import 'package:smartorder/features/order/domain/entities/matched_order_item.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderAnalyzed extends OrderState {
  final List<MatchedOrderItem> matchedItems;
  final double total;

  const OrderAnalyzed({required this.matchedItems, required this.total});

  @override
  List<Object> get props => [matchedItems, total];
}

class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
