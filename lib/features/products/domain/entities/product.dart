import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;

  const Product({required this.id, required this.title, required this.price});

  @override
  List<Object> get props => [id, title, price];

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'price': price};
  }
}
