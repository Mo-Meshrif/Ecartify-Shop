import 'package:flutter/material.dart';

class AlertActionModel {
  final String title;
  final Color? color;
  final void Function() onPressed;

  AlertActionModel({
    required this.title,
    this.color,
    required this.onPressed,
  });
}