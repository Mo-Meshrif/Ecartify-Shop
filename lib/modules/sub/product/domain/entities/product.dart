import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id, name, image, description, price, lastPrice, barcode;
  final List<String> color, size;
  final double avRateValue;
  final int storeAmount, soldNum;
  final DateTime dateAdded;
  final DateTime? offerEndDate;

  const Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.lastPrice,
    required this.barcode,
    required this.color,
    required this.size,
    required this.avRateValue,
    required this.storeAmount,
    required this.soldNum,
    required this.dateAdded,
    this.offerEndDate,
  });

  Product copyWith({double? avRateValue}) => Product(
        id: id,
        name: name,
        image: image,
        description: description,
        price: price,
        lastPrice: lastPrice,
        barcode: barcode,
        color: color,
        size: size,
        avRateValue: avRateValue ?? this.avRateValue,
        storeAmount: storeAmount,
        soldNum: soldNum,
        dateAdded: dateAdded,
        offerEndDate: offerEndDate,
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
        color,
        size,
        avRateValue,
        storeAmount,
        soldNum,
        dateAdded,
        offerEndDate,
      ];
}
