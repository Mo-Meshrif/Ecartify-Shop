import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../../../auth/domain/entities/user.dart';


abstract class BaseProfileRepository {
  Future<Either<Failure, AuthUser>> getUserData();
  Future<Either<Failure,bool>> sendHelpMessage(String message);
}
