import 'package:dartz/dartz.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../domain/repositories/base_promo_repository.dart';
import '../dataSources/remote_data_source.dart';
import '../models/promo_model.dart';

class PromoRepositoryImpl implements BasePromoRepository {
  final BasePromoRemoteDataSource basePromoRemoteDataSource;
  PromoRepositoryImpl(this.basePromoRemoteDataSource);

  @override
  Future<Either<Failure, PromoModel>> checkPromoCode(String promoCode) async {
    try {
      final val = await basePromoRemoteDataSource.checkPromoCode(promoCode);
      return Right(val);
    } on ServerExecption catch (failure) {
      return Left(ServerFailure(msg: failure.msg));
    }
  }
}
