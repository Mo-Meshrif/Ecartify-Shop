import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../app/errors/exception.dart';
import '../models/promo_model.dart';

abstract class BasePromoRemoteDataSource {
  Future<PromoModel> checkPromoCode(String promoCode);
}

class PromoRemoteDataSource extends BasePromoRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  PromoRemoteDataSource(this.firebaseFirestore);

  @override
  Future<PromoModel> checkPromoCode(String promoCode) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore
              .collection('Promo')
              .where('promo_val', isEqualTo: promoCode)
              .where('expiry_date', isGreaterThan: Timestamp.now())
              .get();
      return PromoModel.fromSnapshot(querySnapshot.docs.first);
    } catch (e) {
      throw ServerExecption(e.toString());
    }
  }
}
