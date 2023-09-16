part of 'address_bloc.dart';

class AddressState extends Equatable {
  final Status addressListStatus,
      addAddressStatus,
      editAddressStatus,
      deleteAddressStatus,
      userAddressStatus,
      shippingListStatus,
      userShippingStatus;
  final List<Address> addressList;
  final Address? userAddress;
  final List<Shipping> shippingList;
  final Shipping? userShipping;

  const AddressState({
    this.addressListStatus = Status.sleep,
    this.addAddressStatus = Status.sleep,
    this.editAddressStatus = Status.sleep,
    this.deleteAddressStatus = Status.sleep,
    this.userAddressStatus = Status.sleep,
    this.shippingListStatus = Status.sleep,
    this.addressList = const [],
    this.userAddress,
    this.shippingList = const [],
    this.userShippingStatus = Status.sleep,
    this.userShipping,
  });

  AddressState copyWith({
    Status? addressListStatus,
    Status? addAddressStatus,
    Status? editAddressStatus,
    Status? deleteAddressStatus,
    Status? userAddressStatus,
    Status? shippingListStatus,
    Status? userShippingStatus,
    List<Address>? addressList,
    Address? userAddress,
    List<Shipping>? shippingList,
    Shipping? userShipping,
  }) =>
      AddressState(
        addressListStatus: addressListStatus ?? this.addressListStatus,
        addAddressStatus: addAddressStatus ?? this.addAddressStatus,
        editAddressStatus: editAddressStatus ?? this.editAddressStatus,
        deleteAddressStatus: deleteAddressStatus ?? this.deleteAddressStatus,
        addressList: addressList ?? this.addressList,
        userAddressStatus:
            addressListStatus ?? userAddressStatus ?? this.userAddressStatus,
        userAddress: userAddressStatus == Status.loaded ||
                (addressList?.isEmpty ?? false)
            ? userAddress
            : this.userAddress,
        shippingListStatus: shippingListStatus ?? this.shippingListStatus,
        shippingList: shippingList ?? this.shippingList,
        userShippingStatus: userShippingStatus ?? this.userShippingStatus,
        userShipping: userShippingStatus == Status.loaded
            ? userShipping
            : this.userShipping,
      );

  @override
  List<Object?> get props => [
        addressListStatus,
        addAddressStatus,
        editAddressStatus,
        deleteAddressStatus,
        userAddressStatus,
        shippingListStatus,
        userShippingStatus,
        addressList,
        userAddress,
        shippingList,
        userShipping,
      ];
}
