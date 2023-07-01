import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/category.dart';

abstract class BaseExploreRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, List<Category>>> getSubCategories(String catId);
}
