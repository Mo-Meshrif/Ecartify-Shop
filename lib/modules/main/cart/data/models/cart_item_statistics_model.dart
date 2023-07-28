import '../../domain/entities/cart_item_statistics.dart';

class CartItemStatisticsModel extends CartItemStatistics {
  const CartItemStatisticsModel({
    required String prodId,
    required String color,
    required String size,
    required String quantity,
  }) : super(
          prodId: prodId,
          color: color,
          size: size,
          quantity: quantity,
        );
  factory CartItemStatisticsModel.fromJson(Map<String, dynamic> json) =>
      CartItemStatisticsModel(
        prodId: json['prodId'],
        color: json['color'],
        size: json['size'],
        quantity: json['quantity'],
      );
  Map<String,dynamic> toJson() => {
        'prodId':prodId,
        'color': color,
        'size': size,
        'quantity': quantity,
      };
}
