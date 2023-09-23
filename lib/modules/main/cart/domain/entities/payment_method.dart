import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PaymentMethod extends Equatable {
  final String title, pic;
  final Color? color;

  const PaymentMethod({
    required this.title,
    required this.pic,
    this.color,
  });

  @override
  List<Object?> get props => [
        title,
        pic,
        color,
      ];
}
