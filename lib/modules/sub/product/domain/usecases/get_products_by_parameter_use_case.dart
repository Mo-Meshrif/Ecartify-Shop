import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../entities/product.dart';
import '../repositories/base_product_repository.dart';

class GetCustomProductsUseCase
    implements BaseUseCase<Either<Failure, List<Product>>, ProductsParmeters> {
  final BaseProductRepository baseProductRepository;

  GetCustomProductsUseCase(this.baseProductRepository);
  @override
  Future<Either<Failure, List<Product>>> call(ProductsParmeters parmeters) =>
      baseProductRepository.getCustomProducts(parmeters);
}

class ProductsParmeters extends Equatable {
  final int start;
  final String title;
  final bool fromSearch;
  final String? searchKey;
  final ProductMode? productMode;
  final String lastDateAdded;
  final String catId;
  final String subCatId;
  final List<String> ids;

  const ProductsParmeters({
    this.start = 0,
    this.title = '',
    this.fromSearch = false,
    this.searchKey,
    this.productMode,
    this.catId = '',
    this.subCatId = '',
    this.ids = const [],
    this.lastDateAdded = '2021-02-15T18:42:49.608466Z',
  });
  ProductsParmeters copyWith({
    int? start,
    String? searchKey,
    ProductMode? productMode,
    String? lastDateAdded,
    String? catId,
    String? subCatId,
    List<String>? ids,
  }) =>
      ProductsParmeters(
        start: start ?? this.start,
        fromSearch: fromSearch,
        searchKey: searchKey ?? this.searchKey,
        productMode: productMode ?? this.productMode,
        catId: catId ?? this.catId,
        subCatId: subCatId ?? this.subCatId,
        ids: ids ?? this.ids,
        lastDateAdded: lastDateAdded ?? this.lastDateAdded,
      );
      
  @override
  List<Object?> get props => [
        start,
        fromSearch,
        searchKey,
        productMode,
        catId,
        subCatId,
        ids,
        lastDateAdded,
      ];
}
