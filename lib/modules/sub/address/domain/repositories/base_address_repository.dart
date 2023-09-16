import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/address.dart';
import '../entities/shipping.dart';

abstract class BaseAddressRepository {
  Future<Either<Failure, List<Address>>> getAddressList();
  Future<Either<Failure, Address>> addAddress(Address address);
  Future<Either<Failure, bool>> editAddress(Address address);
  Future<Either<Failure, bool>> deleteAddress(int addressId);
  Future<Either<Failure, List<Shipping>>> getShippingList();
}
