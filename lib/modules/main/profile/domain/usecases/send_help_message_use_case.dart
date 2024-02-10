import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_profile_repository.dart';

class SendHelpMessageUseCase
    implements BaseUseCase<Either<Failure, bool>, String> {
  final BaseProfileRepository baseProfileRepository;
  SendHelpMessageUseCase(this.baseProfileRepository);

  @override
  Future<Either<Failure, bool>> call(String message) =>
      baseProfileRepository.sendHelpMessage(message);
}
