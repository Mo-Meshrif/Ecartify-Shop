import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/helper/enums.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/shipping.dart';
import '../../domain/usecases/add_address_use_case.dart';
import '../../domain/usecases/delete_address_use_case.dart';
import '../../domain/usecases/edit_address_use_case.dart';
import '../../domain/usecases/get_address_list_use_case.dart';
import '../../domain/usecases/get_shipping_list_use_case.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressListUseCase getAddressListUseCase;
  final AddAddressUseCase addAddressUseCase;
  final EditAddressUseCase editAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final GetShippingListUseCase getShippingListUseCase;
  AddressBloc({
    required this.getAddressListUseCase,
    required this.addAddressUseCase,
    required this.editAddressUseCase,
    required this.deleteAddressUseCase,
    required this.getShippingListUseCase,
  }) : super(const AddressState()) {
    on<GetAddressListEvent>(_getAddressList);
    on<AddAddressEvent>(_addAddress);
    on<EditAddressEvent>(_editAddress);
    on<DeleteAddressEvent>(_deleteAddress);
    on<SelectAddressEvent>(_selectAddress);
    on<GetShippingListEvent>(_getShippingList);
    on<SelectShippingEvent>(_selectShipping);
  }

  FutureOr<void> _getAddressList(
      GetAddressListEvent event, Emitter<AddressState> emit) async {
    emit(
      state.copyWith(
        addressListStatus: Status.loading,
        userAddressStatus: Status.sleep,
        addAddressStatus: Status.sleep,
        editAddressStatus: Status.sleep,
        deleteAddressStatus: Status.sleep,
      ),
    );
    var result = await getAddressListUseCase(const NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          addressListStatus: Status.error,
          addressList: [],
        ),
      ),
      (newList) => emit(
        state.copyWith(
          addressListStatus: Status.loaded,
          addressList: newList,
          userAddressStatus: Status.loaded,
          userAddress: newList.isNotEmpty
              ? newList.firstWhere(
                  (e) => e.isDefault,
                  orElse: () => newList.first,
                )
              : null,
        ),
      ),
    );
  }

  FutureOr<void> _addAddress(
      AddAddressEvent event, Emitter<AddressState> emit) async {
    emit(
      state.copyWith(
        addAddressStatus: Status.loading,
        userAddressStatus: Status.sleep,
      ),
    );
    var result = await addAddressUseCase(event.address);
    result.fold(
      (l) => emit(
        state.copyWith(
          addAddressStatus: Status.error,
        ),
      ),
      (address) => emit(
        state.copyWith(
          addAddressStatus: Status.loaded,
          addressList: (address.isDefault
              ? state.addressList
                  .map((e) => e.copyWith(isDefault: false))
                  .toList()
              : state.addressList)
            ..insert(0, address),
          userAddressStatus: Status.loaded,
          userAddress: address.isDefault || state.addressList.length == 1
              ? address
              : state.userAddress,
        ),
      ),
    );
  }

  FutureOr<void> _editAddress(
      EditAddressEvent event, Emitter<AddressState> emit) async {
    emit(
      state.copyWith(
        editAddressStatus: Status.loading,
      ),
    );
    var result = await editAddressUseCase(event.address);
    result.fold(
      (l) => emit(
        state.copyWith(
          editAddressStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          editAddressStatus: Status.loaded,
          addressList: state.addressList
              .map((e) => e.id == event.address.id
                  ? event.address
                  : event.address.isDefault
                      ? e.copyWith(isDefault: false)
                      : e)
              .toList(),
        ),
      ),
    );
  }

  FutureOr<void> _deleteAddress(
      DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(
      state.copyWith(
        deleteAddressStatus: Status.loading,
      ),
    );
    var result = await deleteAddressUseCase(event.addressId);
    result.fold(
      (l) => emit(
        state.copyWith(
          deleteAddressStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteAddressStatus: Status.loaded,
          addressList:
              state.addressList.where((e) => e.id != event.addressId).toList(),
        ),
      ),
    );
  }

  FutureOr<void> _selectAddress(
    SelectAddressEvent event,
    Emitter<AddressState> emit,
  ) async =>
      emit(
        state.copyWith(
          userAddressStatus: Status.loaded,
          userAddress: event.address,
        ),
      );

  FutureOr<void> _getShippingList(
      GetShippingListEvent event, Emitter<AddressState> emit) async {
    emit(
      state.copyWith(
        shippingListStatus: Status.loading,
      ),
    );
    var result = await getShippingListUseCase(const NoParameters());
    result.fold(
      (l) => emit(
        state.copyWith(
          shippingListStatus: Status.error,
          shippingList: [],
        ),
      ),
      (shippingList) => emit(
        state.copyWith(
          shippingListStatus: Status.loaded,
          shippingList: shippingList,
        ),
      ),
    );
  }

  FutureOr<void> _selectShipping(
    SelectShippingEvent event,
    Emitter<AddressState> emit,
  ) async =>
      emit(
        state.copyWith(
          userShippingStatus: Status.loaded,
          userShipping: event.shipping,
        ),
      );
}
