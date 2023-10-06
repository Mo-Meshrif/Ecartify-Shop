import 'package:equatable/equatable.dart';

class Currency extends Equatable {
  final String selectedBase, selectedRate;
  final String? date;
  final Map<String, String>? rates;

  const Currency({
    this.selectedBase = 'USD',
    this.selectedRate = '1',
    this.date,
    this.rates,
  });

  Currency copyWith({
    String? selectedBase,
    String? selectedRate,
  }) =>
      Currency(
        selectedBase: selectedBase ?? this.selectedBase,
        selectedRate: selectedRate ?? this.selectedRate,
        date: date,
        rates: rates,
      );

  @override
  List<Object?> get props => [
        selectedBase,
        selectedRate,
        date,
        rates,
      ];
}
