import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../entities/order.dart';
import '../repositories/base_order_repository.dart';

class GetOrdersUseCase
    implements BaseUseCase<Either<Failure, List<OrderEntity>>, OrderParmeters> {
  final BaseOrderRepository baseOrderRepository;

  GetOrdersUseCase(this.baseOrderRepository);
  @override
  Future<Either<Failure, List<OrderEntity>>> call(
          OrderParmeters orderParmeters) =>
      baseOrderRepository.getOrders(orderParmeters);
}

class OrderParmeters extends Equatable {
  final OrderType orderType;
  final int start;

  const OrderParmeters({
    this.start = 0,
    required this.orderType,
  });

  @override
  List<Object?> get props => [
        start,
        orderType,
      ];
}
