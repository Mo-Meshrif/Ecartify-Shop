import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    int? id,
    required String name,
    required String details,
    required double lat,
    required double lon,
    bool isDefault = false,
  }) : super(
          id: id,
          name: name,
          details: details,
          lat: lat,
          lon: lon,
          isDefault: isDefault,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id'],
        name: json['name'],
        details: json['details'],
        lat: double.parse(json['lat']),
        lon: double.parse(json['lon']),
        isDefault: json['isDefault'] == 1,
      );

  @override
  AddressModel copyWith({int? id, bool? isDefault}) => AddressModel(
        id: id ?? this.id,
        name: name,
        details: details,
        lat: lat,
        lon: lon,
        isDefault: isDefault ?? this.isDefault,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'details': details,
        'lat': lat.toString(),
        'lon': lon.toString(),
        'isDefault': isDefault ? 1 : 0,
      };
}
