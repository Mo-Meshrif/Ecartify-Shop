import 'package:equatable/equatable.dart';

import '../../data/models/cart_item_statistics_model.dart';

class CartItemStatistics extends Equatable {
  final String prodId, color, size, quantity;

  const CartItemStatistics({
    required this.prodId,
    required this.color,
    required this.size,
    required this.quantity,
  });
  CartItemStatistics copyWith(String? quantity) => CartItemStatistics(
        prodId: prodId,
        color: color,
        size: size,
        quantity: quantity ?? this.quantity,
      );
  CartItemStatisticsModel toModel() => CartItemStatisticsModel(
        prodId: prodId,
        color: color,
        size: size,
        quantity: quantity,
      );

  @override
  List<Object?> get props => [
        prodId,
        color,
        size,
        quantity,
      ];
}
