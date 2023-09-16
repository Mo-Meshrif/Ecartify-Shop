import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../../data/models/promo_model.dart';

abstract class BasePromoRepository {
  Future<Either<Failure, PromoModel>> checkPromoCode(String promoCode);
}
