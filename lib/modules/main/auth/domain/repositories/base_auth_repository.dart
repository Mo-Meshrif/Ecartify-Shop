import 'package:dartz/dartz.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/user.dart';
import '../usecases/login_use_case.dart';
import '../usecases/signup_use_case.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, AuthUser>> signIn(LoginInputs userInputs);
  Future<Either<Failure, AuthUser>> signUp(SignUpInputs userInputs);
  Future<Either<Failure, bool>> forgetPassword(String email);
}