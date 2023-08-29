part of 'address_bloc.dart';

class AddressState extends Equatable {
  final Status addressListStatus,
      addAddressStatus,
      editAddressStatus,
      deleteAddressStatus;
  final List<Address> addressList;

  const AddressState({
    this.addressListStatus = Status.sleep,
    this.addAddressStatus = Status.sleep,
    this.editAddressStatus = Status.sleep,
    this.deleteAddressStatus = Status.sleep,
    this.addressList = const [],
  });
  
  AddressState copyWith({
    Status? addressListStatus,
    Status? addAddressStatus,
    Status? editAddressStatus,
    Status? deleteAddressStatus,
    List<Address>? addressList,
  }) =>
      AddressState(
        addressListStatus: addressListStatus ?? this.addressListStatus,
        addAddressStatus: addAddressStatus ?? this.addAddressStatus,
        editAddressStatus: editAddressStatus ?? this.editAddressStatus,
        deleteAddressStatus: deleteAddressStatus ?? this.deleteAddressStatus,
        addressList: addressList ?? this.addressList,
      );

  @override
  List<Object?> get props => [
        addressListStatus,
        addAddressStatus,
        editAddressStatus,
        deleteAddressStatus,
        addressList,
      ];
}
