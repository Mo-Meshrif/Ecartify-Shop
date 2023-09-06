part of 'address_bloc.dart';

class AddressState extends Equatable {
  final Status addressListStatus,
      addAddressStatus,
      editAddressStatus,
      deleteAddressStatus,
      userAddressStatus;
  final List<Address> addressList;
  final Address? userAddress;

  const AddressState({
    this.addressListStatus = Status.sleep,
    this.addAddressStatus = Status.sleep,
    this.editAddressStatus = Status.sleep,
    this.deleteAddressStatus = Status.sleep,
    this.addressList = const [],
    this.userAddressStatus = Status.sleep,
    this.userAddress,
  });

  AddressState copyWith({
    Status? addressListStatus,
    Status? addAddressStatus,
    Status? editAddressStatus,
    Status? deleteAddressStatus,
    List<Address>? addressList,
    Status? userAddressStatus,
    Address? userAddress,
  }) =>
      AddressState(
        addressListStatus: addressListStatus ?? this.addressListStatus,
        addAddressStatus: addAddressStatus ?? this.addAddressStatus,
        editAddressStatus: editAddressStatus ?? this.editAddressStatus,
        deleteAddressStatus: deleteAddressStatus ?? this.deleteAddressStatus,
        addressList: addressList ?? this.addressList,
        userAddressStatus: addressListStatus ??
            userAddressStatus ??
            this.userAddressStatus,
        userAddress: userAddressStatus == Status.loaded ||
                (addressList?.isEmpty ?? false)
            ? userAddress
            : this.userAddress,
      );

  @override
  List<Object?> get props => [
        addressListStatus,
        addAddressStatus,
        editAddressStatus,
        deleteAddressStatus,
        addressList,
        userAddressStatus,
        userAddress,
      ];
}
