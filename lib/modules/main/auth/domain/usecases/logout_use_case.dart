import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../repositories/base_auth_repository.dart';

class LogoutUseCase implements BaseUseCase<Either<Failure, void>, String> {
  final BaseAuthRepository baseAuthRepository;
  LogoutUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, void>> call(String parameters) =>
      baseAuthRepository.logout(parameters);
}
