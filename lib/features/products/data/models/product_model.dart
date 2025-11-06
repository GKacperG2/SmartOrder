import 'package:json_annotation/json_annotation.dart';
import 'package:smartorder/features/products/domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({required int id, required String title, required double price})
    : super(id: id, title: title, price: price);

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
