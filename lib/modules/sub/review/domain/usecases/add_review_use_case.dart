import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/review.dart';
import '../repositories/base_review_repository.dart';

class AddReviewUseCase
    implements BaseUseCase<Either<Failure, List<Review>>, AddReviewParameters> {
  final BaseReviewRepository baseReviewRepository;

  AddReviewUseCase(this.baseReviewRepository);
  @override
  Future<Either<Failure, List<Review>>> call(AddReviewParameters addReviewParameters) =>
      baseReviewRepository.addReview(addReviewParameters);
}

class AddReviewParameters {
  final String title, review, productId, userId, userName;
  final double rateVal;

  AddReviewParameters({
    required this.title,
    required this.review,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rateVal,
  });
  toJson() => {
        'title': title,
        'review': review,
        'product_id': productId,
        'rate_value': rateVal.toStringAsFixed(2),
        'user_id': userId,
        'user_name': userName,
      };
}
