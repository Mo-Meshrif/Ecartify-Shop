import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/address.dart';
import '../repositories/base_address_repository.dart';

class GetAddressListUseCase
    implements BaseUseCase<Either<Failure, List<Address>>, NoParameters> {
  final BaseAddressRepository baseAddressRepository;

  GetAddressListUseCase(this.baseAddressRepository);
  @override
  Future<Either<Failure, List<Address>>> call(_) =>
      baseAddressRepository.getAddressList();
}
