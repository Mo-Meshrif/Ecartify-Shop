import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/services/network_services.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/base_product_repository.dart';
import '../../domain/usecases/get_product_details_use_case.dart';
import '../../domain/usecases/get_products_by_parameter_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../datasources/remote_data_source.dart';

class ProductRepositoryImpl implements BaseProductRepository {
  final BaseProductRemoteDataSource baseProductRemoteDataSource;
  final NetworkServices networkServices;

  ProductRepositoryImpl(this.baseProductRemoteDataSource, this.networkServices);

  @override
  Future<Either<Failure, List<Product>>> getCustomProducts(
      ProductsParmeters parmeters) async {
    if (await networkServices.isConnected()) {
      try {
        final customProducts =
            await baseProductRemoteDataSource.getCustomProducts(parmeters);
        return Right(List<Product>.from(customProducts));
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(
      ProductDetailsParmeters parmeters) async {
    if (await networkServices.isConnected()) {
      try {
        final product =
            await baseProductRemoteDataSource.getProductDetails(parmeters);
        return Right(product);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateProduct(
      ProductParameters updateProductParameters) async {
    if (await networkServices.isConnected()) {
      try {
        await baseProductRemoteDataSource
            .updateProduct(updateProductParameters);
        return const Right(true);
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
