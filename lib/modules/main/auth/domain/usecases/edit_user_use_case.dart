import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class EditUserUseCase implements BaseUseCase<Either<Failure, void>, AuthUser> {
  final BaseAuthRepository baseAuthRepository;
  EditUserUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, void>> call(AuthUser parameters) =>
      baseAuthRepository.editUser(parameters);
}
