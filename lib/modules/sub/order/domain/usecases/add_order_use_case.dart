import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/order.dart';
import '../repositories/base_order_repository.dart';

class AddOrderUseCase
    implements BaseUseCase<Either<Failure, OrderEntity>, OrderEntity> {
  final BaseOrderRepository baseOrderRepository;

  AddOrderUseCase(this.baseOrderRepository);
  @override
  Future<Either<Failure, OrderEntity>> call(OrderEntity order) =>
      baseOrderRepository.addOrder(order);
}
