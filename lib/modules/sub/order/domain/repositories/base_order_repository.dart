import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/order.dart';
import '../usecases/add_order_review_use_case.dart';
import '../usecases/get_orders_use_case.dart';

abstract class BaseOrderRepository {
  Future<Either<Failure, OrderEntity>> addOrder(OrderEntity order);
  Future<Either<Failure,List<OrderEntity>>> getOrders(OrderParmeters orderParmeters);
  Future<Either<Failure, bool>> addOrderReview(OrderReviewParameters orderReviewParameters);
}
