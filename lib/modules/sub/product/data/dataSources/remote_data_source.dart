import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/helper/enums.dart';
import '../../domain/usecases/get_product_details_use_case.dart';
import '../../domain/usecases/get_products_by_parameter_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../models/product_model.dart';

abstract class BaseProductRemoteDataSource {
  Future<List<ProductModel>> getCustomProducts(
      ProductsParmeters productsParmeters);
  Future<ProductModel> getProductDetails(
      ProductDetailsParmeters productDetailsParmeters);
  Future<void> updateProduct(ProductParameters updateProductParameters);
}

class ProductRemoteDataSource implements BaseProductRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  ProductRemoteDataSource(this.firebaseFirestore);
  DocumentSnapshot? lastSearchedSnap,
      lastSellerSnap,
      lastOfferSnap,
      lastCatSnap,
      lastSubSnap;

  @override
  Future<List<ProductModel>> getCustomProducts(
      ProductsParmeters productsParmeters) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Products');
      late Query<Map<String, dynamic>> query;
      late QuerySnapshot<Map<String, dynamic>> querySnapshot;
      if (productsParmeters.searchKey != null) {
        String searchKey = productsParmeters.searchKey!;
        query = collection
            .where('name', isGreaterThanOrEqualTo: searchKey)
            .where('name', isLessThan: searchKey + 'z')
            .orderBy('name');
        querySnapshot = await _getQuerySnapshot(
          productsParmeters.start == 0 ? null : lastSearchedSnap,
          query,
        );
        lastSearchedSnap = querySnapshot.docs.last;
      } else if (productsParmeters.productMode == ProductMode.bestSellerProds) {
        query = collection
            .where('sold_num', isGreaterThan: 0)
            .orderBy('sold_num', descending: true);
        querySnapshot = await _getQuerySnapshot(
          productsParmeters.start == 0 ? null : lastSellerSnap,
          query,
        );
        lastSellerSnap = querySnapshot.docs.last;
      } else if (productsParmeters.productMode == ProductMode.offerProds) {
        query = collection
            .where(
              'offer_end_date',
              isGreaterThanOrEqualTo: Timestamp.fromDate(
                DateTime.now().subtract(
                  const Duration(days: 1),
                ),
              ),
            )
            .orderBy('offer_end_date', descending: true);
        querySnapshot = await _getQuerySnapshot(
          productsParmeters.start == 0 ? null : lastOfferSnap,
          query,
        );
        lastOfferSnap = querySnapshot.docs.last;
      } else if (productsParmeters.catId.isNotEmpty) {
        query = collection.where(
          'cat-id',
          isEqualTo: productsParmeters.catId,
        );
        querySnapshot = await _getQuerySnapshot(
          productsParmeters.start == 0 ? null : lastCatSnap,
          query,
        );
        lastCatSnap = querySnapshot.docs.last;
      } else if (productsParmeters.subCatId.isNotEmpty) {
        query = collection.where(
          'sub-id',
          isEqualTo: productsParmeters.subCatId,
        );
        querySnapshot = await _getQuerySnapshot(
          productsParmeters.start == 0 ? null : lastSubSnap,
          query,
        );
        lastSubSnap = querySnapshot.docs.last;
      } else if (productsParmeters.ids.isNotEmpty) {
        querySnapshot = await collection
            .where(FieldPath.documentId, whereIn: productsParmeters.ids)
            .get();
      } else {
        query = collection;
        querySnapshot = await collection.get();
      }
      return querySnapshot.docs
          .map((e) => ProductModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getQuerySnapshot(
      DocumentSnapshot? documentSnapshot,
      Query<Map<String, dynamic>> query) async {
    if (documentSnapshot == null) {
      return await query
          .orderBy('date_added', descending: true)
          .limit(10)
          .get();
    } else {
      return await query
          .orderBy('date_added', descending: true)
          .startAfter([documentSnapshot])
          .limit(10)
          .get();
    }
  }

  @override
  Future<ProductModel> getProductDetails(
      ProductDetailsParmeters productDetailsParmeters) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Products');
      if (productDetailsParmeters.productId != null) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            await collection.doc(productDetailsParmeters.productId).get();
        return ProductModel.fromSnapshot(documentSnapshot);
      } else {
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await collection
            .where('barcode', isEqualTo: productDetailsParmeters.productBarcode)
            .get();
        return ProductModel.fromSnapshot(querySnapshot.docs.first);
      }
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }

  @override
  Future<void> updateProduct(ProductParameters updateProductParameters) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Products');
      collection
          .doc(updateProductParameters.product.id)
          .update(updateProductParameters.toJson());
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
