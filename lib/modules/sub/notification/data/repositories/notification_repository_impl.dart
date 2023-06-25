import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../domain/usecases/read_notification_use_case.dart';
import '/app/services/network_services.dart';
import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/base_notification_repository.dart';
import '../datasources/remote_data_source.dart';

class NotificationRepositoryImpl implements BaseNotificationRepository {
  final BaseNotificationRemoteDataSource baseNotificaionRemoteDataSource;
  final NetworkServices networkServices;

  NotificationRepositoryImpl(
    this.baseNotificaionRemoteDataSource,
    this.networkServices,
  );

  @override
  Future<Either<Failure, List<Notification>>> getNotificationsList() async {
    if (await networkServices.isConnected()) {
      try {
        final notifications =
            await baseNotificaionRemoteDataSource.getNotificationsList();
        return Right(List<Notification>.from(notifications));
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String id) async {
    if (await networkServices.isConnected()) {
      try {
        final val =
            await baseNotificaionRemoteDataSource.deleteNotification(id);
        return Right(val);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, Notification>> getNotificationDetails(
      String id) async {
    if (await networkServices.isConnected()) {
      try {
        final notification =
            await baseNotificaionRemoteDataSource.getNotificationDetails(id);
        return Right(notification);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnReadNotificationNum() async {
    if (await networkServices.isConnected()) {
      try {
        final val =
            await baseNotificaionRemoteDataSource.getUnReadNotificationNum();
        return Right(val);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, void>> readNotification(
      UpdateNotification updateNotification) async {
    if (await networkServices.isConnected()) {
      try {
        final val = await baseNotificaionRemoteDataSource
            .readNotification(updateNotification);
        return Right(val);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
