import 'package:equatable/equatable.dart';

import '../../data/models/address_model.dart';

class Address extends Equatable {
  final String id, name, details, lat, lon;
  final bool isDefault;

  const Address({
    required this.id,
    required this.name,
    required this.details,
    required this.lat,
    required this.lon,
    this.isDefault = false,
  });

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
