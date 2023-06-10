import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class GoogleUseCase implements BaseUseCase<Either<Failure, AuthUser>, NoParameters> {
  final BaseAuthRepository baseAuthRepository;

  GoogleUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, AuthUser>> call(NoParameters parameters) => baseAuthRepository.google();
}
