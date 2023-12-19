import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/common/usecase/base_use_case.dart';
import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../../../app/helper/helper_functions.dart';
import '../../../../sub/product/domain/entities/product.dart';
import '../../../../sub/product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/cart_item_statistics.dart';
import '../../domain/usecases/add_item_to_cart_use_case.dart';
import '../../domain/usecases/change_quantity_use_case.dart';
import '../../domain/usecases/delete_item_use_case.dart';
import '../../domain/usecases/get_cart_items_use_case.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final GetCustomProductsUseCase getCustomProductsUseCase;
  final AddItemToCartUseCase addItemToCartUseCase;
  final ChangeQuantityUseCase changeQuantityUseCase;
  final DeleteItemUseCase deleteItemUseCase;
  CartBloc({
    required this.getCartItemsUseCase,
    required this.getCustomProductsUseCase,
    required this.addItemToCartUseCase,
    required this.changeQuantityUseCase,
    required this.deleteItemUseCase,
  }) : super(const CartState()) {
    on<GetCartItems>(_getCartItems);
    on<GetCartItemsProds>(_getCartProducts);
    on<AddItemToCartEvent>(_addItemToCart);
    on<ChangeQuantityEvent>(_changeQuantity);
    on<DeleteItemEvent>(_deleteItem);
    on<ClearCartEvent>(
      (event, emit) => emit(
        const CartState(),
      ),
    );
  }

  FutureOr<void> _getCartItems(
      GetCartItems event, Emitter<CartState> emit) async {
    emit(state.copyWith(cartStatus: Status.loading));
    Either<Failure, List<CartItem>> result =
        await getCartItemsUseCase(const NoParameters());
    result.fold(
      (failure) => emit(
        event.cartInit
            ? state.copyWith(
                cartStatus: Status.error,
              )
            : state.copyWith(
                cartItemsNumber: 0,
              ),
      ),
      (items) => event.cartInit
          ? add(
              GetCartItemsProds(
                items,
              ),
            )
          : emit(
              state.copyWith(
                cartItems: items,
                cartItemsNumber: HelperFunctions.refactorCartItemLength(items),
              ),
            ),
    );
  }

  FutureOr<void> _addItemToCart(
      AddItemToCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(addItemStatus: Status.loading));
    Either<Failure, bool> result = await addItemToCartUseCase(event.statistics);
    result.fold(
      (failure) => emit(state.copyWith(addItemStatus: Status.error)),
      (_) => emit(
        state.copyWith(
          addItemStatus: Status.loaded,
          cartItems: event.prodIsInCart
              ? state.cartItems
                  .map(
                    (e) => e.prodId == event.product.id
                        ? e.copyWith(
                            statistics: [event.statistics, ...e.statistics])
                        : e,
                  )
                  .toList()
              : [
                  CartItem(
                    prodId: event.product.id,
                    product: event.product,
                    statistics: [
                      event.statistics,
                    ],
                  ),
                  ...state.cartItems
                ],
          cartItemsNumber: state.cartItemsNumber +
              int.parse(
                event.statistics.quantity,
              ),
        ),
      ),
    );
  }

  FutureOr<void> _getCartProducts(
      GetCartItemsProds event, Emitter<CartState> emit) async {
    List<String> ids = event.items.map((e) => e.prodId).toList();
    Either<Failure, List<Product>> result =
        await getCustomProductsUseCase(ProductsParmeters(ids: ids));
    result.fold(
      (failure) => emit(
        state.copyWith(
          cartStatus: Status.error,
        ),
      ),
      (prods) => emit(
        state.copyWith(
          cartStatus: Status.loaded,
          cartItems: List.from(event.items
              .map((e) => e.copyWith(
                  product: prods.firstWhere((prod) => prod.id == e.prodId)))
              .toList()),
        ),
      ),
    );
  }

  FutureOr<void> _changeQuantity(
      ChangeQuantityEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(changeQuantityStatus: Status.loading));
    CartItemStatistics statistics = event.statistics;
    Either<Failure, void> result = await changeQuantityUseCase(statistics);
    result.fold(
      (failure) => emit(
        state.copyWith(
          changeQuantityStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          changeQuantityStatus: Status.loaded,
          cartItems: state.cartItems
              .map(
                (e) => e.prodId == statistics.prodId
                    ? e.copyWith(
                        statistics: statistics.quantity == '0'
                            ? e.statistics
                                .where((e) =>
                                    e.color != statistics.color ||
                                    e.size != statistics.size)
                                .toList()
                            : e.statistics
                                .map((e) => e.color == statistics.color &&
                                        e.size == statistics.size
                                    ? statistics
                                    : e)
                                .toList(),
                      )
                    : e,
              )
              .toList(),
        ),
      ),
    );
  }

  FutureOr<void> _deleteItem(
      DeleteItemEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(deleteItemStatus: Status.loading));
    Either<Failure, bool> result = await deleteItemUseCase(event.prodId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteItemStatus: Status.error,
        ),
      ),
      (_) => emit(
        state.copyWith(
          deleteItemStatus: Status.loaded,
          cartItems: state.cartItems
              .where(
                (e) => e.prodId != event.prodId,
              )
              .toList(),
        ),
      ),
    );
  }
}
