import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/cart_item_statistics.dart';
import '../repositories/base_cart_repository.dart';

class AddItemToCartUseCase
    implements BaseUseCase<Either<Failure, bool>, CartItemStatistics> {
  final BaseCartRepository baseCartRepository;
  AddItemToCartUseCase(this.baseCartRepository);

  @override
  Future<Either<Failure, bool>> call(CartItemStatistics parmeters) =>
      baseCartRepository.addToCart(parmeters);
}