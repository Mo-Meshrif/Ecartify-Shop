part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class GetReviewsEvent extends ReviewEvent {
  final String productId;
  const GetReviewsEvent({required this.productId});
}
class AddReviewEvent extends ReviewEvent{
  final AddReviewParameters addReviewParameters;
  const AddReviewEvent({required this.addReviewParameters});
}