import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/promo.dart';

class PromoModel extends Promo {
  const PromoModel({
    required String id,
    required String promoVal,
    required String discount,
    required DateTime expiryDate,
  }) : super(
          id: id,
          promoVal: promoVal,
          discount: discount,
          expiryDate: expiryDate,
        );

  factory PromoModel.fromSnapshot(DocumentSnapshot snapshot) => PromoModel(
        id: snapshot.id,
        promoVal: snapshot.get('promo_val'),
        discount: snapshot.get('discount'),
        expiryDate: snapshot.get('expiry_date') is Timestamp
            ? (snapshot.get('expiry_date') as Timestamp).toDate()
            : DateTime.parse(snapshot.get('expiry_date')),
      );
}
