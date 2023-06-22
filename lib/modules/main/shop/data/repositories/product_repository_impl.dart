import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../app/errors/exception.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/services/network_services.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../domain/entities/slider_banner.dart';
import '../../domain/repositories/base_shop_repository.dart';
import '../datasources/remote_data_source.dart';

class ShopRepositoryImpl implements BaseShopRepository {
  final BaseShopRemoteDataSource baseShopRemoteDataSource;
  final NetworkServices networkServices;

  ShopRepositoryImpl(this.baseShopRemoteDataSource, this.networkServices);

  @override
  Future<Either<Failure, List<SliderBanner>>> getSliderBanners() async {
    if (await networkServices.isConnected()) {
      try {
        final sliderBanners = await baseShopRemoteDataSource.getSliderBanners();
        return Right(List<SliderBanner>.from(sliderBanners));
      } on ServerExecption catch (_) {
        return Left(ServerFailure(msg: AppStrings.operationFailed.tr()));
      }
    } else {
      return Left(ServerFailure(msg: AppStrings.noConnection.tr()));
    }
  }
}
