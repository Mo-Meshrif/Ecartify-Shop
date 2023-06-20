import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/helper/enums.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final GetCustomProductsUseCase getCustomProductsUseCase;
  ShopBloc({required this.getCustomProductsUseCase})
      : super(const ShopState()) {
    on<GetBestSellerProductsEvent>(_getBestSellerProducts);
  }

  FutureOr<void> _getBestSellerProducts(
      GetBestSellerProductsEvent event, Emitter<ShopState> emit) async {
    emit(state.copyWith(bestSellerProdStatus: Status.initial));
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
}