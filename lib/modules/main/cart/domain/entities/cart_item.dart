import 'package:equatable/equatable.dart';

import '../../../../sub/product/domain/entities/product.dart';
import '../../data/models/cart_item_model.dart';
import 'cart_item_statistics.dart';

class CartItem extends Equatable {
  final String prodId;
  final String sellerPrice;
  final Product? product;
  final List<CartItemStatistics> statistics;

  const CartItem({
    required this.prodId,
    this.sellerPrice='0',
    this.product,
    required this.statistics,
  });

  CartItem copyWith({
    String? sellerPrice,
    Product? product,
    List<CartItemStatistics>? statistics,
  }) =>
      CartItem(
        prodId: prodId,
        sellerPrice: sellerPrice??this.sellerPrice,
        product: product ?? this.product,
        statistics: statistics ?? this.statistics,
      );

  CartItemModel toModel() => CartItemModel(
        prodId: prodId,
        sellerPrice: sellerPrice,
        product: product,
        statistics: statistics,
      );

  @override
  List<Object?> get props => [
        prodId,
        product,
        sellerPrice,
        statistics,
      ];
}
