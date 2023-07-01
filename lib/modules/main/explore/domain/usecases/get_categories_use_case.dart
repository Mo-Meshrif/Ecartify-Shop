import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/category.dart';
import '../repositories/base_explore_repository.dart';

class GetCategoriesUseCase
    implements BaseUseCase<Either<Failure, List<Category>>, NoParameters> {
  final BaseExploreRepository baseExploreRepository;

  GetCategoriesUseCase(this.baseExploreRepository);
  @override
  Future<Either<Failure, List<Category>>> call(_) =>
      baseExploreRepository.getCategories();
}
