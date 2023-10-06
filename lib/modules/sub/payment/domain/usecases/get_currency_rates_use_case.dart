import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/currency.dart';
import '../repositories/base_payment_repository.dart';

class GetCurrencyRatesUseCase
    implements BaseUseCase<Either<Failure, Currency>, NoParameters> {
  final BasePaymentRepository basePaymentRepository;
  GetCurrencyRatesUseCase(this.basePaymentRepository);
  
  @override
  Future<Either<Failure, Currency>> call( _) =>
      basePaymentRepository.getCurrencyRates();
}
