import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/cart_item.dart';
import '../entities/cart_item_statistics.dart';

abstract class BaseCartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, bool>> addToCart(CartItemStatistics statistics);
  Future<Either<Failure, bool>> changeQuantity(CartItemStatistics statistics);
  Future<Either<Failure, bool>> deleteItem(String prodId);
}
