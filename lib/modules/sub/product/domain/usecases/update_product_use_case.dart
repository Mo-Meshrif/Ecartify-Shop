import 'package:dartz/dartz.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../entities/product.dart';
import '../repositories/base_product_repository.dart';

class UpdateProductUseCase
    implements BaseUseCase<Either<Failure, bool>, ProductParameters> {
  final BaseProductRepository baseProductRepository;

  UpdateProductUseCase(this.baseProductRepository);
  @override
  Future<Either<Failure, bool>> call(ProductParameters parmeters) =>
      baseProductRepository.updateProduct(parmeters);
}

class ProductParameters {
  final Product product;
  ProductParameters({required this.product});
  toJson() => {
        'name': product.name,
        'image': product.image,
        'description': product.description,
        'price': product.price,
        'last_price': product.lastPrice,
        'barcode': product.barcode,
        'color': product.color,
        'size': product.size,
        'rate_value': product.avRateValue.toStringAsFixed(2),
        'store_amount': product.storeAmount.toString(),
        'sold_num': product.soldNum,
        'date_added': product.dateAdded,
      };
}
