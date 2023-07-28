import 'package:dartz/dartz.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_item_statistics.dart';
import '../../domain/repositories/base_cart_repository.dart';
import '../datasources/local_data_source.dart';

class CartRepositoryImpl implements BaseCartRepository {
  final BaseCartLocalDataSource baseCartLocalDataSource;
  CartRepositoryImpl(this.baseCartLocalDataSource);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await baseCartLocalDataSource.getCartItems();
      return Right(List<CartItem>.from(items));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, bool>> addToCart(CartItemStatistics statistics) async {
    try {
      final val = await baseCartLocalDataSource.addToCart(statistics.toModel());
      return val
          ? const Right(true)
          : const Left(LocalFailure(msg: AppStrings.operationFailed));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, bool>> changeQuantity(
    CartItemStatistics statistics,
  ) async {
    try {
      final val =
          await baseCartLocalDataSource.changeQuantity(statistics.toModel());
      return val
          ? const Right(true)
          : const Left(LocalFailure(msg: AppStrings.operationFailed));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteItem(String prodId) async {
    try {
      final val = await baseCartLocalDataSource.deleteItem(prodId);
      return val
          ? const Right(true)
          : const Left(LocalFailure(msg: AppStrings.operationFailed));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }
}
