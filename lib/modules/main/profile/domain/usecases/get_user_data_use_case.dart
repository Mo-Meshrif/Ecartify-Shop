import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../repositories/base_profile_repository.dart';

class GetUserDataUseCase
    implements BaseUseCase<Either<Failure, AuthUser>, NoParameters> {
  final BaseProfileRepository baseProfileRepository;
  GetUserDataUseCase(this.baseProfileRepository);

  @override
  Future<Either<Failure, AuthUser>> call(_) =>
      baseProfileRepository.getUserData();
}
