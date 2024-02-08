import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_order_repository.dart';

class AddOrderReviewUseCase
    implements BaseUseCase<Either<Failure, bool>, OrderReviewParameters> {
  final BaseOrderRepository baseOrderRepository;

  AddOrderReviewUseCase(this.baseOrderRepository);
  @override
  Future<Either<Failure, bool>> call(OrderReviewParameters parameters) =>
      baseOrderRepository.addOrderReview(parameters);
}

class OrderReviewParameters extends Equatable {
  final String orderId, note;
  final double rate;

  const OrderReviewParameters({
    required this.orderId,
    required this.note,
    required this.rate,
  });

  @override
  List<Object?> get props => [
        orderId,
        note,
        rate,
      ];
}
