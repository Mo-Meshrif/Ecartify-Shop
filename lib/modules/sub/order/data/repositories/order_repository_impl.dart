import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/usecases/get_orders_use_case.dart';
import '/app/services/network_services.dart';
import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/base_order_repository.dart';
import '../datasources/remote_data_source.dart';

class OrderRepositoryImpl implements BaseOrderRepository {
  final BaseOrderRemoteDataSource baseOrderRemoteDataSource;
  final NetworkServices networkServices;

  OrderRepositoryImpl(
    this.baseOrderRemoteDataSource,
    this.networkServices,
  );

  @override
  Future<Either<Failure, OrderEntity>> addOrder(OrderEntity order) async {
    if (await networkServices.isConnected()) {
      try {
        final orderData =
            await baseOrderRemoteDataSource.addOrder(order.toModel());
        return Right(orderData);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders(OrderParmeters orderParmeters) async {
    if (await networkServices.isConnected()) {
      try {
        final orders = await baseOrderRemoteDataSource.getOrders(orderParmeters);
        return Right(orders);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
