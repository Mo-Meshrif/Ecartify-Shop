import '../../../../sub/product/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_item_statistics.dart';
import 'cart_item_statistics_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel(
      {required String prodId,
      String sellerPrice = '0',
      Product? product,
      required List<CartItemStatistics> statistics})
      : super(
          prodId: prodId,
          sellerPrice: sellerPrice,
          product: product,
          statistics: statistics,
        );
        
  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        prodId: json['id'],
        sellerPrice: json['seller_price'],
        statistics: List.from(json['statistics'])
            .map((e) => CartItemStatisticsModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': prodId,
        'seller_price': sellerPrice,
        'statistics': statistics.map((e) => e.toModel().toJson()).toList()
      };
}
