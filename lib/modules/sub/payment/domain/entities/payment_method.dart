import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../app/helper/enums.dart';

class PaymentMethod extends Equatable {
  final String title, pic;
  final Color? color;
  final PaymentType paymentType;

  const PaymentMethod({
    required this.title,
    required this.pic,
    this.color,
    required this.paymentType,
  });

  @override
  List<Object?> get props => [
        title,
        pic,
        color,
        paymentType,
      ];
}
