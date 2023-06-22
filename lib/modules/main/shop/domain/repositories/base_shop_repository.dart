import 'package:dartz/dartz.dart';

import '../../../../../app/errors/failure.dart';
import '../entities/slider_banner.dart';

abstract class BaseShopRepository {
  Future<Either<Failure, List<SliderBanner>>> getSliderBanners();
}
