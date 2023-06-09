import 'package:dartz/dartz.dart';
import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';

import '../../../../../app/services/network_services.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/base_auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/signup_use_case.dart';
import '../datasources/remote_data_source.dart';

class AuthRepositoryImpl implements BaseAuthRepository {
  final BaseAuthRemoteDataSource baseAuthRemoteDataSource;
  final NetworkServices networkServices;

  AuthRepositoryImpl(
    this.baseAuthRemoteDataSource,
    this.networkServices,
  );

  @override
  Future<Either<Failure, AuthUser>> signIn(LoginInputs userInputs) async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.signIn(userInputs);
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppStrings.noConnection));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUp(SignUpInputs userInputs) async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseAuthRemoteDataSource.signUp(userInputs);
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppStrings.noConnection));
    }
  }

  @override
  Future<Either<Failure, bool>> forgetPassword(String email) async {
    if (await networkServices.isConnected()) {
      try {
        final bool isRest = await baseAuthRemoteDataSource.forgetPassord(email);
        return Right(isRest);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppStrings.noConnection));
    }
  }
}
