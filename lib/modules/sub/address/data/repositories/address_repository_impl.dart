import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/address.dart';
import '../../domain/entities/shipping.dart';
import '../../domain/repositories/base_address_repository.dart';
import '../dataSources/local_data_source.dart';
import '../dataSources/remote_data_source.dart';

class AddressRepositoryImpl implements BaseAddressRepository {
  final BaseAddressLocalDataSource baseAddressLocalDataSource;
  final BaseAddressRemoteDataSource baseAddressRemoteDataSource;
  AddressRepositoryImpl(
    this.baseAddressLocalDataSource,
    this.baseAddressRemoteDataSource,
  );

  @override
  Future<Either<Failure, List<Address>>> getAddressList() async {
    try {
      final addressList = await baseAddressLocalDataSource.getAddressList();
      return Right(List<Address>.from(addressList));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, Address>> addAddress(Address address) async {
    try {
      final val =
          await baseAddressLocalDataSource.addAddress(address.toModel());
      return val == null
          ? Left(LocalFailure(msg: AppStrings.operationFailed.tr()))
          : Right(val);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, bool>> editAddress(Address address) async {
    try {
      final val = await baseAddressLocalDataSource.editAddress(
        address.toModel(),
      );
      return val
          ? const Right(true)
          : left(LocalFailure(msg: AppStrings.operationFailed.tr()));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAddress(int addressId) async {
    try {
      final val = await baseAddressLocalDataSource.deleteAddress(addressId);
      return val
          ? const Right(true)
          : left(LocalFailure(msg: AppStrings.operationFailed.tr()));
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<Failure, List<Shipping>>> getShippingList() async {
    try {
      final shippingList = await baseAddressRemoteDataSource.getShippingList();
      return Right(List<Shipping>.from(shippingList));
    } on ServerExecption catch (failure) {
      return Left(ServerFailure(msg: failure.msg));
    }
  }
}
