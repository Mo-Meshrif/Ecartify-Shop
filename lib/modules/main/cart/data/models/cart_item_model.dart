import '../../../../sub/product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_item_statistics.dart';

class CartItemModel extends CartItem {
  const CartItemModel(
      {required String prodId,
      Product? product,
      required List<CartItemStatistics> statistics})
      : super(
          prodId: prodId,
          product: product,
          statistics: statistics,
        );
}
