import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/services/network_services.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/repositories/base_payment_repository.dart';
import '../../domain/usecases/get_paymob_ifram_id_use_case.dart';
import '../../domain/usecases/get_stripe_client_secret_use_case.dart';
import '../datasources/remote_data_source.dart';

class PaymentRepositoryImpl implements BasePaymentRepository {
  final BasePaymentRemoteDataSource basePaymentRemoteDataSource;
  final NetworkServices networkServices;

  PaymentRepositoryImpl(this.basePaymentRemoteDataSource, this.networkServices);

  @override
  Future<Either<Failure, String>> getStripeClientSecret(StripeClientSecretParameters parameters) async {
    if (await networkServices.isConnected()) {
      try {
        final clientSecret =
            await basePaymentRemoteDataSource.getStripeClientSecret(parameters);
        return Right(clientSecret);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
  
  @override
  Future<Either<Failure, String>> getPaymobIframeId(PaymobIFrameParameters parameters)async {
   if (await networkServices.isConnected()) {
      try {
        final paymobToken =
            await basePaymentRemoteDataSource.getPaymobIframeId(parameters);
        return Right(paymobToken);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
