import 'package:equatable/equatable.dart';

import '../../data/models/address_model.dart';

class Address extends Equatable {
  final int? id;
  final String name, details;
  final double lat, lon;
  final bool isDefault,selected;

  const Address({
    this.id,
    required this.name,
    required this.details,
    required this.lat,
    required this.lon,
    this.isDefault = false,
    this.selected=false,
  });

  Address copyWith({bool? isDefault,bool? selected}) => Address(
        id: id,
        name: name,
        details: details,
        lat: lat,
        lon: lon,
        isDefault: isDefault ?? this.isDefault,
        selected: selected ?? this.selected,
      );
      
  AddressModel toModel() => AddressModel(
        id: id,
        name: name,
        details: details,
        lat: lat,
        lon: lon,
        isDefault: isDefault,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        details,
        lat,
        lon,
        isDefault,
        selected,
      ];
}
