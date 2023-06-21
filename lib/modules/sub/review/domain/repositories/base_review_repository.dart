import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/review.dart';
import '../usecases/add_review_use_case.dart';

abstract class BaseReviewRepository {
  Future<Either<Failure, List<Review>>> getReviews(String productId);
  Future<Either<Failure, List<Review>>> addReview(AddReviewParameters addReviewParameters);
}
