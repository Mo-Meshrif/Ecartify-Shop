import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_cart_repository.dart';

class DeleteItemUseCase implements BaseUseCase<Either<Failure, bool>, String> {
  final BaseCartRepository baseCartRepository;
  DeleteItemUseCase(this.baseCartRepository);

  @override
  Future<Either<Failure, bool>> call(String prodId) =>
      baseCartRepository.deleteItem(prodId);
}
