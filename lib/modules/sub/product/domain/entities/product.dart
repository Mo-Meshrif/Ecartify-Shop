import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id, name, image, description, price, lastPrice, barcode;
  final List<String> color, size;
  final double avRateValue;
  final int storeAmount, soldNum;
  final String dateAdded;

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
  });

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
      ];
}