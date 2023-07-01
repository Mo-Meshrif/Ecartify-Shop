import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/services/network_services.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/base_explore_repository.dart';
import '../datasources/remote_data_source.dart';

class ExploreRepositoryImpl implements BaseExploreRepository {
  final BaseExploreRemoteDataSource baseExploreRemoteDataSource;
  final NetworkServices networkServices;

  ExploreRepositoryImpl(this.baseExploreRemoteDataSource, this.networkServices);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    if (await networkServices.isConnected()) {
      try {
        final cats = await baseExploreRemoteDataSource.getCategories();
        return Right(List<Category>.from(cats));
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<Category>>> getSubCategories(String catId) async {
    if (await networkServices.isConnected()) {
      try {
        final subCats =
            await baseExploreRemoteDataSource.getSubCategories(catId);
        return Right(List<Category>.from(subCats));
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
