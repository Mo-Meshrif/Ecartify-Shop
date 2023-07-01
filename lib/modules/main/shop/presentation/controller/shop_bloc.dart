import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../../../sub/product/domain/usecases/update_product_use_case.dart';
import '../../domain/entities/slider_banner.dart';
import '../../domain/usecases/get_sliders_banners_use_case.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetSliderBannersUseCase getSliderBannersUseCase;
  final GetCustomProductsUseCase getCustomProductsUseCase;
  ShopBloc({
    required this.getSliderBannersUseCase,
    required this.getCustomProductsUseCase,
  }) : super(const ShopState()) {
    on<GetSliderBannersEvent>(_getSliderBanners);
    on<GetOfferProductsEvent>(_getOfferProducts);
    on<GetBestSellerProductsEvent>(_getBestSellerProducts);
    on<UpdateShopProductsEvent>(_updateProduct);
  }

  FutureOr<void> _getSliderBanners(
      GetSliderBannersEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(sliderBanneStatus: Status.loading));
    var result = await getSliderBannersUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        state.copyWith(
          sliderBanneStatus: Status.error,
          sliderBanners: [],
        ),
      ),
      (sliders) => emit(
        state.copyWith(
          sliderBanneStatus: Status.loaded,
          sliderBanners: sliders,
        ),
      ),
    );
  }

  FutureOr<void> _getOfferProducts(
      GetOfferProductsEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(offerProdStatus: Status.loading));
    var result = await getCustomProductsUseCase(
      const ProductsParmeters(
        productMode: ProductMode.offerProds,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          offerProdStatus: Status.error,
          offerProds: [],
        ),
      ),
      (prods) => emit(
        state.copyWith(
          offerProds: prods,
          offerProdStatus: Status.loaded,
        ),
      ),
    );
  }

  FutureOr<void> _getBestSellerProducts(
      GetBestSellerProductsEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(bestSellerProdStatus: Status.loading));
    var result = await getCustomProductsUseCase(
      const ProductsParmeters(
        productMode: ProductMode.bestSellerProds,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          bestSellerProdStatus: Status.error,
          bestSellerProds: [],
        ),
      ),
      (prods) => emit(
        state.copyWith(
          bestSellerProds: prods,
          bestSellerProdStatus: Status.loaded,
        ),
      ),
    );
  }

  FutureOr<void> _updateProduct(
      UpdateShopProductsEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(
      offerProdStatus: Status.updating,
      bestSellerProdStatus: Status.updating,
    ));
    emit(
      state.copyWith(
        offerProdStatus: Status.updating,
        offerProds: state.offerProds
            .map((e) => e.id == event.productParameters.product.id
                ? event.productParameters.product
                : e)
            .toList(),
        bestSellerProdStatus: Status.updated,
        bestSellerProds: state.bestSellerProds
            .map((e) => e.id == event.productParameters.product.id
                ? event.productParameters.product
                : e)
            .toList(),
      ),
    );
  }
}
