part of 'review_bloc.dart';

class ReviewState extends Equatable {
  final Status reviewStatus;
  final List<Review> reviews;
  final Status addreviewStatus;

  const ReviewState({
    this.reviewStatus = Status.sleep,
    this.reviews = const [],
    this.addreviewStatus = Status.sleep,
  });

  ReviewState copyWith({
    Status? reviewStatus,
    List<Review>? reviews,
    Status? addreviewStatus,
  }) =>
      ReviewState(
        reviewStatus: reviewStatus ?? this.reviewStatus,
        reviews: reviews ?? this.reviews,
        addreviewStatus: addreviewStatus ?? this.addreviewStatus,
      );

  @override
  List<Object?> get props => [
        reviewStatus,
        reviews,
        addreviewStatus,
      ];
}
