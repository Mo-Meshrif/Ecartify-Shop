import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/helper/enums.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../../domain/usecases/get_reviews_use_case.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;
  ReviewBloc({
    required this.getReviewsUseCase,
    required this.addReviewUseCase,
  }) : super(const ReviewState()) {
    on<GetReviewsEvent>(_getReviews);
    on<AddReviewEvent>(_addReview);
  }

  FutureOr<void> _getReviews(
      GetReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(
      reviewStatus: Status.loading,
      addreviewStatus: Status.sleep,
      reviews: [],
    ));
    var result = await getReviewsUseCase(event.productId);
    result.fold(
      (failure) => emit(state.copyWith(
        reviewStatus: Status.error,
        reviews: [],
      )),
      (reviews) => emit(
        state.copyWith(
          reviewStatus: Status.loaded,
          reviews: reviews,
        ),
      ),
    );
  }

  FutureOr<void> _addReview(
      AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(
      addreviewStatus: Status.loading,
    ));
    var result = await addReviewUseCase(event.addReviewParameters);
    result.fold(
      (failure) => emit(state.copyWith(
        addreviewStatus: Status.error,
      )),
      (reviews) => emit(
        state.copyWith(
          addreviewStatus: reviews.isNotEmpty ? Status.loaded : Status.error,
          reviews: reviews.isNotEmpty ? reviews : state.reviews,
        ),
      ),
    );
  }
}
