import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id, name, image, description, price, lastPrice, barcode, catName;
  final List<String> color, size;
  final double avRateValue;
  final int storeAmount, soldNum;
  final DateTime dateAdded;
  final DateTime? offerEndDate;
  final bool isFavourite;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.lastPrice,
    required this.barcode,
    required this.catName,
    required this.color,
    required this.size,
    required this.avRateValue,
    required this.storeAmount,
    required this.soldNum,
    required this.dateAdded,
    this.offerEndDate,
    required this.isFavourite,
  });

  Product copyWith({double? avRateValue, bool? isFavourite}) => Product(
        id: id,
        name: name,
        image: image,
        description: description,
        price: price,
        lastPrice: lastPrice,
        barcode: barcode,
        catName: catName,
        color: color,
        size: size,
        avRateValue: avRateValue ?? this.avRateValue,
        storeAmount: storeAmount,
        soldNum: soldNum,
        dateAdded: dateAdded,
        offerEndDate: offerEndDate,
        isFavourite: isFavourite ?? this.isFavourite,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        description,
        price,
        lastPrice,
        barcode,
        catName,
        color,
        size,
        avRateValue,
        storeAmount,
        soldNum,
        dateAdded,
        offerEndDate,
      ];
}
