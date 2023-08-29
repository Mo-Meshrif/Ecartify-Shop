import 'package:equatable/equatable.dart';

import '../../data/models/address_model.dart';

class Address extends Equatable {
  final int? id;
  final String name, details;
  final double lat, lon;
  final bool isDefault;

  const Address({
    this.id,
    required this.name,
    required this.details,
    required this.lat,
    required this.lon,
    this.isDefault = false,
  });

  Address copyWith({bool? isDefault}) => Address(
        id: id,
        name: name,
        details: details,
        lat: lat,
        lon: lon,
        isDefault: isDefault ?? this.isDefault,
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
      ];
}
