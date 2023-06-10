import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class DeleteUseCase implements BaseUseCase<Either<Failure, void>, AuthUser> {
  final BaseAuthRepository baseAuthRepository;
  DeleteUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, void>> call(AuthUser parameters) =>
      baseAuthRepository.delete(parameters);
}
