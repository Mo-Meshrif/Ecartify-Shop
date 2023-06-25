import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/notification.dart';
import '../usecases/read_notification_use_case.dart';

abstract class BaseNotificationRepository {
  Future<Either<Failure, List<Notification>>> getNotificationsList();
  Future<Either<Failure, int>> getUnReadNotificationNum();
  Future<Either<Failure, void>> deleteNotification(String id);
  Future<Either<Failure, void>> readNotification(UpdateNotification updateNotification);
  Future<Either<Failure, Notification>> getNotificationDetails(String id);
}
