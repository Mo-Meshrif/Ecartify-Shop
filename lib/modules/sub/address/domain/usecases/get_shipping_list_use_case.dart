import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/shipping.dart';
import '../repositories/base_address_repository.dart';

class GetShippingListUseCase
    implements BaseUseCase<Either<Failure, List<Shipping>>, NoParameters> {
  final BaseAddressRepository baseAddressRepository;

  GetShippingListUseCase(this.baseAddressRepository);
  @override
  Future<Either<Failure, List<Shipping>>> call(_) =>
      baseAddressRepository.getShippingList();
}
