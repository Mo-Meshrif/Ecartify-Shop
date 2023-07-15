import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../helper/enums.dart';

class FilterParameters extends Equatable {
  final String category;
  final RangeValues priceRange;
  final ProductSort productSort;
  final int rate, count;
  final bool hasNewData;

  const FilterParameters({
    required this.category,
    required this.priceRange,
    required this.productSort,
    required this.rate,
    this.count = 0,
    this.hasNewData = false,
  });

  FilterParameters copyWith({
    String? category,
    RangeValues? priceRange,
    ProductSort? productSort,
    int? rate,
    int? count,
    bool? hasNewData,
  }) =>
      FilterParameters(
        category: category ?? this.category,
        priceRange: priceRange ?? this.priceRange,
        productSort: productSort ?? this.productSort,
        rate: rate ?? this.rate,
        count: count ?? this.count,
        hasNewData: hasNewData ?? this.hasNewData,
      );
  @override
  List<Object?> get props => [
        category,
        priceRange,
        productSort,
        rate,
        count,
        hasNewData,
      ];
}
