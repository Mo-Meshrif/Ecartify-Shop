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
import '../../domain/usecases/update_product_use_case.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetCustomProductsUseCase getCustomProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final UpdateProductUseCase updateProductUseCase;
  ProductBloc({
    required this.getCustomProductsUseCase,
    required this.getProductDetailsUseCase,
    required this.updateProductUseCase,
  }) : super(const ProductState()) {
    on<GetCustomProductsEvent>(_getCustomProducts);
    on<GetSearchedProductsEvent>(
      _getSearchedProducts,
      transformer: droppable(),
    );
    on<GetProductDetailsEvent>(_getProductDetails);
    on<UpdateProductDetailsEvent>(_updateProductDetails);
    on<UpdateProductEvent>(_updateProduct);
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

  FutureOr<void> _getSearchedProducts(
      GetSearchedProductsEvent event, Emitter<ProductState> emit) async {
    if (!state.isSearchedProdMax || event.productsParmeters.start == 0) {
      emit(
        state.copyWith(
          searchedProdStatus: event.productsParmeters.start == 0
              ? Status.initial
              : Status.loading,
          searchedProds:
              event.productsParmeters.start == 0 ? [] : state.searchedProds,
        ),
      );
      Either<Failure, List<Product>> result =
          await getCustomProductsUseCase(event.productsParmeters);
      result.fold(
        (failure) => emit(state.copyWith(
          searchedProdStatus: Status.error,
          searchedProds: state.customProds,
        )),
        (prods) => emit(
          state.copyWith(
            searchedProdStatus: Status.loaded,
            searchedProds: List.from(state.searchedProds)..addAll(prods),
            isSearchedProdMax: prods.length < 10,
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

  FutureOr<void> _updateProductDetails(
          UpdateProductDetailsEvent event, Emitter<ProductState> emit) async =>
      emit(
        state.copyWith(
          productDetailsStatus: Status.updated,
          productDetails: event.product,
        ),
      );

  FutureOr<void> _updateProduct(
      UpdateProductEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(
      updateProductStatus: Status.loading,
    ));
    Either<Failure, bool> result =
        await updateProductUseCase(event.productParameters);
    result.fold(
      (failure) => emit(state.copyWith(
        updateProductStatus: Status.error,
      )),
      (_) => emit(
        state.copyWith(
          updateProductStatus: Status.loaded,
          productDetails: state.productDetails == null
              ? null
              : event.productParameters.product,
          customProds: state.customProds
              .map((e) => e.id == event.productParameters.product.id
                  ? event.productParameters.product
                  : e)
              .toList(),
        ),
      ),
    );
  }
}
