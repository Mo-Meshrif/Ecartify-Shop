import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_address_repository.dart';

class DeleteAddressUseCase
    implements BaseUseCase<Either<Failure, bool>, int> {
  final BaseAddressRepository baseAddressRepository;

  DeleteAddressUseCase(this.baseAddressRepository);
  @override
  Future<Either<Failure, bool>> call(int addressId) =>
      baseAddressRepository.deleteAddress(addressId);
}
