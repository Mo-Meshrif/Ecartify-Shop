import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../models/category_model.dart';

abstract class BaseExploreRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getSubCategories(String catId);
}

class ExploreRemoteDataSource implements BaseExploreRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  ExploreRemoteDataSource(this.firebaseFirestore);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Categories');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.orderBy('date-added').get();
      return querySnapshot.docs
          .map((e) => CategoryModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getSubCategories(String catId) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Sub-Categories');
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
          .where('parent-id', isEqualTo: catId)
          .orderBy('date-added')
          .get();
      return querySnapshot.docs
          .map((e) => CategoryModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
