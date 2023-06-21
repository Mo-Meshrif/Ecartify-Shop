import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required String id,
    required String title,
    required String review,
    required String productId,
    required double rateVal,
    required String userId,
    required String userName,
  }) : super(
          id: id,
          title: title,
          review: review,
          productId: productId,
          rateVal: rateVal,
          userId: userId,
          userName: userName,
        );
  factory ReviewModel.fromSnapshot(DocumentSnapshot snapshot) => ReviewModel(
        id: snapshot.id,
        title: snapshot.get('title'),
        review: snapshot.get('review'),
        productId: snapshot.get('product_id'),
        rateVal: double.parse(snapshot.get('rate_value') ?? '0.0'),
        userId: snapshot.get('user_id'),
        userName: snapshot.get('user_name'),
      );
}
