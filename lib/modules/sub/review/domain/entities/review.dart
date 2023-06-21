import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id, title, review, productId, userId, userName;
  final double rateVal;

  const Review({
    required this.id,
    required this.title,
    required this.review,
    required this.productId,
    required this.rateVal,
    required this.userId,
    required this.userName,
  });
  @override
  List<Object?> get props => [
        id,
        title,
        review,
        productId,
        rateVal,
        userId,
        userName,
      ];
}
