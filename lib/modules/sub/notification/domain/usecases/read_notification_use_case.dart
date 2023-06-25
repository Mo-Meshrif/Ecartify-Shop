import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/notification.dart';
import '../repositories/base_notification_repository.dart';

class ReadNotificationUseCase
    implements BaseUseCase<Either<Failure, void>, UpdateNotification> {
  final BaseNotificationRepository baseNotificationRepository;

  ReadNotificationUseCase(this.baseNotificationRepository);
  @override
  Future<Either<Failure, void>> call(UpdateNotification parameter) =>
      baseNotificationRepository.readNotification(parameter);
}

class UpdateNotification {
  final Notification notification;
  UpdateNotification({required this.notification});
  toJson() => {
        'page-type': notification.pageType,
        'url': notification.url,
        'status': '0',
        'date-added': Timestamp.fromDate(
          DateTime.parse(notification.dateAdded),
        ),
        'title': notification.title,
        'content': notification.content,
      };
}
