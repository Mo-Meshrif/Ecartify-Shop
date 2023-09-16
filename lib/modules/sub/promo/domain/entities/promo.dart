import 'package:equatable/equatable.dart';

class Promo extends Equatable {
  final String id, promoVal, discount;
  final DateTime expiryDate;

  const Promo({
    required this.id,
    required this.promoVal,
    required this.discount,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [
        id,
        promoVal,
        discount,
        expiryDate,
      ];
}
