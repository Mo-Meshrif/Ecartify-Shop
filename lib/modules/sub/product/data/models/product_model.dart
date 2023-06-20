import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String id,
    required String name,
    required String image,
    required String description,
    required String price,
    required String lastPrice,
    required String barcode,
    required List<String> color,
    required List<String> size,
    required double avRateValue,
    required int storeAmount,
    required int soldNum,
    required String dateAdded,
  }) : super(
          id: id,
          name: name,
          image: image,
          description: description,
          price: price,
          lastPrice: lastPrice,
          barcode: barcode,
          color: color,
          size: size,
          avRateValue: avRateValue,
          storeAmount: storeAmount,
          soldNum: soldNum,
          dateAdded: dateAdded,
        );
  factory ProductModel.fromSnapshot(DocumentSnapshot snapshot) => ProductModel(
      id: snapshot.id,
      name: snapshot.get('name'),
      image: snapshot.get('image'),
      description: snapshot.get('description'),
      price: snapshot.get('price'),
      lastPrice: snapshot.get('last_price'),
      barcode: snapshot.get('barcode'),
      color: (snapshot.get('color') as List).map((e) => e.toString()).toList(),
      size: (snapshot.get('size') as List).map((e) => e.toString()).toList(),
      avRateValue: double.parse(snapshot.get('rate_value') ?? '0.0'),
      storeAmount: int.parse(snapshot.get('store_amount') ?? '0.0'),
      soldNum: int.parse(snapshot.get('sold_num').toString()),
      dateAdded: snapshot.get('date_added').toString(),
    );
}
