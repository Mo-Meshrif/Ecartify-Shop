import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/notification.dart';
import '../repositories/base_notification_repository.dart';

class GetNotificationsUseCase
    implements BaseUseCase<Either<Failure, List<Notification>>, NoParameters> {
  final BaseNotificationRepository baseNotificationRepository;

  GetNotificationsUseCase(this.baseNotificationRepository);
  @override
  Future<Either<Failure, List<Notification>>> call(NoParameters noParameters) =>
      baseNotificationRepository.getNotificationsList();
}
