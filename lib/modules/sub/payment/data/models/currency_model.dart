import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/helper/helper_functions.dart';
import '../../domain/entities/currency.dart';

class CurrencyModel extends Currency {
  const CurrencyModel({
    required String selectedBase,
    required String selectedRate,
    String? date,
    Map<String, String>? rates,
  }) : super(
          selectedBase: selectedBase,
          selectedRate: selectedRate,
          date: date,
          rates: rates,
        );

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    bool hasData = json['rates'] != null;
    String currencyBase = HelperFunctions.getSelectedCurrencyBase();
    return CurrencyModel(
      selectedBase: HelperFunctions.setCurrencyBase(
        hasData ? currencyBase : 'USD',
      ),
      selectedRate: HelperFunctions.setCurrencyRate(
        hasData ? json['rates'][currencyBase] : '1',
      ),
      date: hasData
          ? DateFormat('yyyy-MM-dd').format(DateTime.parse(json['date']))
          : null,
      rates: hasData ? Map.from(json['rates']) : null,
    );
  }

  toJson() => {
        'date': date,
        'rates': rates,
      };
}
