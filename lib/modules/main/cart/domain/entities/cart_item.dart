import 'package:equatable/equatable.dart';

import '../../../../sub/product/domain/entities/product.dart';
import '../../data/models/cart_item_model.dart';
import 'cart_item_statistics.dart';

class CartItem extends Equatable {
  final String prodId;
  final Product? product;
  final List<CartItemStatistics> statistics;

  const CartItem({
    required this.prodId,
    this.product,
    required this.statistics,
  });

  CartItem copyWith({
    Product? product,
    List<CartItemStatistics>? statistics,
  }) =>
      CartItem(
        prodId: prodId,
        product: product ?? this.product,
        statistics: statistics ?? this.statistics,
      );

  CartItemModel toModel() => CartItemModel(
        prodId: prodId,
        product: product,
        statistics: statistics,
      );

  @override
  List<Object?> get props => [
        product,
        statistics,
      ];
}
