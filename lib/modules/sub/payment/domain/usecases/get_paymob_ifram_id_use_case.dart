import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_payment_repository.dart';

class GetPaymobIframeIdUseCase
    implements BaseUseCase<Either<Failure, String>, PaymobIFrameParameters> {
  final BasePaymentRepository basePaymentRepository;

  GetPaymobIframeIdUseCase(this.basePaymentRepository);
  @override
  Future<Either<Failure, String>> call(PaymobIFrameParameters parameters) =>
      basePaymentRepository.getPaymobIframeId(parameters);
}

class PaymobIFrameParameters extends Equatable {
  final String amount, currency, firstName, lastName,email, mobile;
  const PaymobIFrameParameters({
    required this.amount,
    required this.currency,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
  });

  @override
  List<Object?> get props => [
        amount,
        currency,
        firstName,
        lastName,
        email,
        mobile,
      ];
}
