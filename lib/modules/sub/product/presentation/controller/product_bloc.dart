import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_details_use_case.dart';
import '../../domain/usecases/get_products_by_parameter_use_case.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetCustomProductsUseCase getCustomProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  ProductBloc({
    required this.getCustomProductsUseCase,
    required this.getProductDetailsUseCase,
  }) : super(const ProductState()) {
    on<GetCustomProductsEvent>(
      _getCustomProducts,
      transformer: droppable(),
    );
    on<GetProductDetailsEvent>(_getProductDetails);
  }

  FutureOr<void> _getCustomProducts(
      GetCustomProductsEvent event, Emitter<ProductState> emit) async {
    if (!state.isCustomProdMax || event.productsParmeters.start == 0) {
      emit(
        state.copyWith(
          customProdStatus: event.productsParmeters.start == 0
              ? Status.initial
              : Status.loading,
          customProds:
              event.productsParmeters.start == 0 ? [] : state.customProds,
        ),
      );
      Either<Failure, List<Product>> result =
          await getCustomProductsUseCase(event.productsParmeters);
      result.fold(
        (failure) => emit(state.copyWith(
          customProdStatus: Status.error,
          customProds: state.customProds,
        )),
        (prods) => emit(
          state.copyWith(
            customProdStatus: Status.loaded,
            customProds: List.from(state.customProds)..addAll(prods),
            isCustomProdMax: prods.length < 10,
          ),
        ),
      );
    }
  }

  FutureOr<void> _getProductDetails(
      GetProductDetailsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      productDetailsStatus: Status.loading,
      productDetails: null,
    ));
    Either<Failure, Product> result = await getProductDetailsUseCase(
      event.productDetailsParmeters,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        productDetailsStatus: Status.error,
        productDetails: null,
      )),
      (prod) => emit(
        state.copyWith(
          productDetailsStatus: Status.loaded,
          productDetails: prod,
        ),
      ),
    );
  }
}
