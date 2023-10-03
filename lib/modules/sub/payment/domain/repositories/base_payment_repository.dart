import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../usecases/get_paymob_ifram_id_use_case.dart';
import '../usecases/get_stripe_client_secret_use_case.dart';

abstract class BasePaymentRepository {
  Future<Either<Failure, String>> getStripeClientSecret(
    StripeClientSecretParameters parameters,
  );
  Future<Either<Failure, String>> getPaymobIframeId(
    PaymobIFrameParameters parameters,
  );
}
