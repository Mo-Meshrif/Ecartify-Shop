import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/base_product_repository.dart';

class GetProductDetailsUseCase
    implements BaseUseCase<Either<Failure, Product>, ProductDetailsParmeters> {
  final BaseProductRepository baseProductRepository;

  GetProductDetailsUseCase(this.baseProductRepository);
  @override
  Future<Either<Failure, Product>> call(ProductDetailsParmeters parmeters) =>
      baseProductRepository.getProductDetails(parmeters);
}

class ProductDetailsParmeters extends Equatable {
  final String? productId, productBarcode;

  const ProductDetailsParmeters({this.productId, this.productBarcode});

  @override
  List<Object?> get props => [
        productId,
        productBarcode,
      ];
}
