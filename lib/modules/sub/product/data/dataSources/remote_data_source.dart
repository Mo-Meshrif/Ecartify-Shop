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

  @override
  Future<List<ProductModel>> getCustomProducts(
      ProductsParmeters productsParmeters) async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Products');
      late Query<Map<String, dynamic>> query;
      if (productsParmeters.searchKey != null) {
        String searchKey = productsParmeters.searchKey!;
        query = collection
            .where('name', isGreaterThanOrEqualTo: searchKey)
            .where('name', isLessThan: searchKey + 'z')
            .orderBy('name');
        // collection.add({
        //   'name': "MIZUNO MENS TOUR PERFORMANCE 3D LOGO STRETCH FIT GOLF CAP / NEW 2023 MODEL",
        //   'image': 'https://firebasestorage.googleapis.com/v0/b/ecartify-shop.appspot.com/o/Products%2Fs-l1600a.png?alt=media&token=275f1e74-c355-46a8-889b-47feae3e0efb',
        //   'description': '',
        //   'price': '16.99',
        //   'last_price': '',
        //   'barcode': '',
        //   'color':['#000000','#ffffff'],
        //   'size': [],
        //   'rate_value': '0',
        //   'store_amount': '10',
        //   'sold_num': 3,
        //   'date_added': Timestamp.now(),
        // });
      } else if (productsParmeters.productMode == ProductMode.bestSellerProds) {
        query = collection
            .where('sold_num', isGreaterThan: 0)
            .orderBy('sold_num', descending: true);
      } else {
        query = collection;
      }
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query
          .orderBy('date_added', descending: true)
          .startAfter([productsParmeters.lastDateAdded])
          .limit(10)
          .get();
      return querySnapshot.docs
          .map((e) => ProductModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
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
