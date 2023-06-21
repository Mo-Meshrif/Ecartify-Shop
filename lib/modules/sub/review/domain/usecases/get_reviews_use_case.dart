import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/review.dart';
import '../repositories/base_review_repository.dart';

class GetReviewsUseCase
    implements BaseUseCase<Either<Failure, List<Review>>, String> {
  final BaseReviewRepository baseReviewRepository;

  GetReviewsUseCase(this.baseReviewRepository);
  @override
  Future<Either<Failure, List<Review>>> call(String productId) =>
      baseReviewRepository.getReviews(productId);
}
