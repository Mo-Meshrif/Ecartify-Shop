import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../models/shipping_model.dart';

abstract class BaseAddressRemoteDataSource {
  Future<List<ShippingModel>> getShippingList();
}

class AddressRemoteDataSource implements BaseAddressRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  AddressRemoteDataSource(this.firebaseFirestore);

  @override
  Future<List<ShippingModel>> getShippingList() async {
    try {
      CollectionReference<Map<String, dynamic>> collection =
          firebaseFirestore.collection('Shipping-Types');
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collection.get();
      return querySnapshot.docs
          .map((e) => ShippingModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
