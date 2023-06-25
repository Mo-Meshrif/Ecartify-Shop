import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/notification.dart';
import '../repositories/base_notification_repository.dart';

class GetNotificationDetailsUseCase
    implements BaseUseCase<Either<Failure, Notification>, String> {
  final BaseNotificationRepository baseNotificationRepository;

  GetNotificationDetailsUseCase(this.baseNotificationRepository);
  @override
  Future<Either<Failure, Notification>> call(String parameter) =>
      baseNotificationRepository.getNotificationDetails(parameter);
}
