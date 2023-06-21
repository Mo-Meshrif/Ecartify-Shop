import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../../domain/usecases/add_review_use_case.dart';
import '../models/review_model.dart';

abstract class BaseReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviews(String productId);
  Future<List<ReviewModel>> addReview(AddReviewParameters addReviewParameters);
}

class ReviewRemoteDataSource implements BaseReviewRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  ReviewRemoteDataSource(this.firebaseFirestore);

  @override
  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Reviews');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.where('product_id', isEqualTo: productId).get();
      return querySnapshot.docs
          .map((e) => ReviewModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<List<ReviewModel>> addReview(
      AddReviewParameters addReviewParameters) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Reviews');
      DocumentReference<Map<String, dynamic>> documentReference =
          await collection.add(addReviewParameters.toJson());
      return documentReference.id.isEmpty
          ? []
          : await getReviews(addReviewParameters.productId);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
