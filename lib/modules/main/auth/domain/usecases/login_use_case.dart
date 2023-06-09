import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../repositories/base_auth_repository.dart';

class LoginUseCase
    implements BaseUseCase<Either<Failure, AuthUser>, LoginInputs> {
  final BaseAuthRepository baseAuthRepository;
  LoginUseCase(this.baseAuthRepository);

  @override
  Future<Either<Failure, AuthUser>> call(LoginInputs parameters) =>
      baseAuthRepository.signIn(parameters);
}

class LoginInputs extends Equatable {
  final String email, password;
  const LoginInputs({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}