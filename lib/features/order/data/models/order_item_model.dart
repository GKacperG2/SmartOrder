import 'package:json_annotation/json_annotation.dart';
import 'package:smartorder/features/order/domain/entities/order_item.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemModel extends OrderItem {
  const OrderItemModel({required super.name, required super.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
