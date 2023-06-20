import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/product.dart';
import '../usecases/get_product_details_use_case.dart';
import '../usecases/get_products_by_parameter_use_case.dart';

abstract class BaseProductRepository {
  Future<Either<Failure, List<Product>>> getCustomProducts(
    ProductsParmeters parmeters,
  );
  Future<Either<Failure, Product>> getProductDetails(
    ProductDetailsParmeters parmeters,
  );
}
