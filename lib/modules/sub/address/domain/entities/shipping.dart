import 'package:equatable/equatable.dart';

class Shipping extends Equatable {
  final String id, title, img, price;
  final DateTime arrivalDate;
  final bool selected;

  const Shipping({
    required this.id,
    required this.title,
    required this.img,
    required this.price,
    required this.arrivalDate,
    this.selected = false,
  });

  Shipping copyWith(bool? selected) => Shipping(
        id: id,
        title: title,
        img: img,
        price: price,
        arrivalDate: arrivalDate,
        selected: selected ?? this.selected,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        img,
        price,
        arrivalDate,
        selected,
      ];
}
