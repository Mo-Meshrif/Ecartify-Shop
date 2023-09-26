import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_payment_repository.dart';

class GetStripeClientSecretUseCase
    implements BaseUseCase<Either<Failure, String>, StripeClientSecretParameters> {
  final BasePaymentRepository basePaymentRepository;

  GetStripeClientSecretUseCase(this.basePaymentRepository);
  @override
  Future<Either<Failure, String>> call(StripeClientSecretParameters parmeters) =>
      basePaymentRepository.getStripeClientSecret(parmeters);
}

class StripeClientSecretParameters {
  final String amount, currency;

  StripeClientSecretParameters({
    required this.amount,
    required this.currency,
  });

  toJson() => {
        'amount': amount,
        'currency': currency,
      };
}
