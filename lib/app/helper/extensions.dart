import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/strings_manager.dart';

extension StringCasingExtension on String {
  String _toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str._toCapitalized())
      .join(' ');

  String reductionStringNumber(BuildContext context) {
    double doubleNumber = double.tryParse(this) ?? 0;
    NumberFormat numberFormat =
        NumberFormat.compact(locale: context.locale.languageCode);
    return numberFormat.format(doubleNumber);
  }
}

extension DateConversion on DateTime {
  String toHourMark() {
    int hour = this.hour;
    if (hour > 12) {
      return AppStrings.goodNight;
    } else if (hour > 24) {
      return AppStrings.goodMorning;
    } else {
      return AppStrings.goodMorning;
    }
  }
}
