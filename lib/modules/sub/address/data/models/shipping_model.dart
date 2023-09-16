import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/shipping.dart';

class ShippingModel extends Shipping {
  const ShippingModel({
    required String id,
    required String title,
    required String img,
    required String price,
    required DateTime arrivalDate,
    bool selected = false,
  }) : super(
          id: id,
          title: title,
          img: img,
          price: price,
          arrivalDate: arrivalDate,
          selected: selected,
        );
  factory ShippingModel.fromSnapshot(DocumentSnapshot snapshot) =>
      ShippingModel(
        id: snapshot.id,
        title: snapshot.get('title'),
        img: snapshot.get('img'),
        price: snapshot.get('price'),
        arrivalDate: DateTime.now().add(
          Duration(
            days: int.tryParse(snapshot.get('arrival_in_day')) ?? 0,
          ),
        ),
      );
}
