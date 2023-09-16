part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class GetAddressListEvent extends AddressEvent {}

class AddAddressEvent extends AddressEvent {
  final Address address;
  const AddAddressEvent({required this.address});
}

class EditAddressEvent extends AddressEvent {
  final Address address;
  const EditAddressEvent({required this.address});
}

class DeleteAddressEvent extends AddressEvent {
  final int addressId;
  const DeleteAddressEvent({required this.addressId});
}

class SelectAddressEvent extends AddressEvent {
  final Address address;
  const SelectAddressEvent({required this.address});
}

class GetShippingListEvent extends AddressEvent {}

class SelectShippingEvent extends AddressEvent {
  final Shipping shipping;
  const SelectShippingEvent({required this.shipping});
}
