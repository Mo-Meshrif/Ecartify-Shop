import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/promo.dart';
import '../repositories/base_promo_repository.dart';

class CheckPromoCodeUseCase
    implements BaseUseCase<Either<Failure, Promo>, String> {
  final BasePromoRepository basePromoRepository;
  CheckPromoCodeUseCase(this.basePromoRepository);
  
  @override
  Future<Either<Failure, Promo>> call(String promoCode) =>
      basePromoRepository.checkPromoCode(promoCode);
}
