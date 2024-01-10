import 'package:dartz/dartz.dart';
import '../../../../../app/common/usecase/base_use_case.dart';

import '../../../../../app/errors/failure.dart';
import '../repositories/base_cart_repository.dart';

class DeleteAllItemsUseCase implements BaseUseCase<Either<Failure, bool>, NoParameters> {
  final BaseCartRepository baseCartRepository;
  DeleteAllItemsUseCase(this.baseCartRepository);

  @override
  Future<Either<Failure, bool>> call(_) =>
      baseCartRepository.deleteAllItems();
}