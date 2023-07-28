import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/cart_item.dart';
import '../repositories/base_cart_repository.dart';

class GetCartItemsUseCase
    implements BaseUseCase<Either<Failure, List<CartItem>>, NoParameters> {
  final BaseCartRepository baseCartRepository;
  GetCartItemsUseCase(this.baseCartRepository);

  @override
  Future<Either<Failure, List<CartItem>>> call(_) =>
      baseCartRepository.getCartItems();
}
