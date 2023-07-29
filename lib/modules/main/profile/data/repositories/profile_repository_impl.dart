import 'package:dartz/dartz.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/services/network_services.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/repositories/base_profile_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';

class ProfileRepositoryImpl implements BaseProfileRepository {
  final BaseProfileRemoteDataSource baseProfileRemoteDataSource;
  final BaseProfileLocalDataSource baseProfileLocalDataSource;
  final NetworkServices networkServices;

  ProfileRepositoryImpl(
    this.baseProfileRemoteDataSource,
    this.baseProfileLocalDataSource,
    this.networkServices,
  );

  @override
  Future<Either<Failure, AuthUser>> getUserData() async {
    if (await networkServices.isConnected()) {
      try {
        final user = await baseProfileRemoteDataSource.getUserData();
        baseProfileLocalDataSource.saveUserData(user);
        return Right(user);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      try {
        final user = await baseProfileLocalDataSource.getUserData();
        return Right(user);
      } on LocalExecption catch (failure) {
        return Left(LocalFailure(msg: failure.msg));
      }
    }
  }
}
