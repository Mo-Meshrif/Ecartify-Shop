import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class AppleUseCase
    implements BaseUseCase<Either<Failure, AuthUser>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  AppleUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, AuthUser>> call(NoParameters parameters) =>
      baseAuthRepository.apple();
}
