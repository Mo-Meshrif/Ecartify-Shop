import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/services/network_services.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/base_review_repository.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../dataSource/remote_data_source.dart';

class ReviewRepositoryImpl implements BaseReviewRepository {
  final BaseReviewRemoteDataSource baseReviewRemoteDataSource;
  final NetworkServices networkServices;

  ReviewRepositoryImpl(this.baseReviewRemoteDataSource, this.networkServices);

  @override
  Future<Either<Failure, List<Review>>> getReviews(String productId) async {
    if (await networkServices.isConnected()) {
      try {
        final reviews = await baseReviewRemoteDataSource.getReviews(productId);
        return Right(List<Review>.from(reviews));
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> addReview(
      AddReviewParameters addReviewParameters) async {
    if (await networkServices.isConnected()) {
      try {
        final value =
            await baseReviewRemoteDataSource.addReview(addReviewParameters);
        return Right(value);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
