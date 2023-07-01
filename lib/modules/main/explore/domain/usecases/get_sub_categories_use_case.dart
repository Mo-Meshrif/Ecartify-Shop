import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/category.dart';
import '../repositories/base_explore_repository.dart';

class GetSubCategoriesUseCase
    implements BaseUseCase<Either<Failure, List<Category>>, String> {
  final BaseExploreRepository baseExploreRepository;

  GetSubCategoriesUseCase(this.baseExploreRepository);
  @override
  Future<Either<Failure, List<Category>>> call(String catId) =>
      baseExploreRepository.getSubCategories(catId);
}
