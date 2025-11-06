import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String name;
  final int quantity;

  const OrderItem({required this.name, required this.quantity});

  @override
  List<Object> get props => [name, quantity];
}
