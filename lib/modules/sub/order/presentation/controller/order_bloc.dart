import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../app/errors/failure.dart';
import '../../../../../app/helper/enums.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/usecases/get_products_by_parameter_use_case.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/add_order_review_use_case.dart';
import '../../domain/usecases/add_order_use_case.dart';
import '../../domain/usecases/get_orders_use_case.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AddOrderUseCase addOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final GetCustomProductsUseCase getCustomProductsUseCase;
  final AddOrderReviewUseCase addOrderReviewUseCase;
  OrderBloc({
    required this.addOrderUseCase,
    required this.getOrdersUseCase,
    required this.getCustomProductsUseCase,
    required this.addOrderReviewUseCase,
  }) : super(const OrderState()) {
    on<AddOrderEvent>(
      _addOrder,
      transformer: droppable(),
    );

    on<GetOrdersEvent>(
      _getOrders,
      transformer: droppable(),
    );
    on<GetOrderItemsProds>(_getOrderProducts);
    on<AddOrderReviewEvent>(
      _addOrderReview,
      transformer: sequential(),
    );
  }

  FutureOr<void> _addOrder(
      AddOrderEvent event, Emitter<OrderState> emit) async {
    emit(
      state.copyWith(
        addOrderStatus: Status.loading,
      ),
    );
    Either<Failure, OrderEntity> result = await addOrderUseCase(event.order);
    result.fold(
      (failure) => emit(
        state.copyWith(
          addOrderStatus: Status.error,
        ),
      ),
      (order) => emit(
        state.copyWith(
          addOrderStatus: Status.loaded,
          tempOrder: order,
        ),
      ),
    );
  }

  FutureOr<void> _getOrders(
      GetOrdersEvent event, Emitter<OrderState> emit) async {
    bool init = event.orderParmeters.start == 0;
    if (init || !state.isOrdersMax) {
      emit(
        state.copyWith(
          getOrderListStatus: init ? Status.initial : Status.loading,
          orders: init ? [] : state.orders,
        ),
      );
      var result = await getOrdersUseCase(event.orderParmeters);
      result.fold(
        (failure) => emit(
          state.copyWith(
            getOrderListStatus: Status.error,
          ),
        ),
        (orders) => add(GetOrderItemsProds(orders)),
      );
    }
  }

  FutureOr<void> _getOrderProducts(
      GetOrderItemsProds event, Emitter<OrderState> emit) async {
    List<String> ids = [];
    for (var i = 0; i < event.orders.length; i++) {
      for (var element in event.orders[i].items) {
        ids = [...ids, element.prodId];
      }
    }
    Either<Failure, List<Product>> result =
        await getCustomProductsUseCase(ProductsParmeters(ids: ids));
    result.fold(
      (failure) => emit(
        state.copyWith(
          getOrderListStatus: Status.error,
        ),
      ),
      (prods) => emit(
        state.copyWith(
          getOrderListStatus: Status.loaded,
          isOrdersMax: event.orders.length < 5,
          orders: [
            ...state.orders,
            ...event.orders
                .map(
                  (order) => order.copyWith(
                    items: order.items
                        .map(
                          (e) => e.copyWith(
                            product: prods.firstWhere(
                              (prod) => prod.id == e.prodId,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  FutureOr<void> _addOrderReview(
      AddOrderReviewEvent event, Emitter<OrderState> emit) async {
    emit(
      state.copyWith(
        addOrderReviewStatus: Status.loading,
      ),
    );
    Either<Failure, bool> result =
        await addOrderReviewUseCase(event.orderReviewParameters);
    result.fold(
      (failure) => emit(
        state.copyWith(
          addOrderReviewStatus: Status.error,
        ),
      ),
      (result) => emit(
        state.copyWith(
          addOrderReviewStatus: result ? Status.loaded : Status.error,
          orders: result
              ? state.orders
                  .map((e) => e.id == event.orderReviewParameters.orderId
                      ? e.copyWith(rate: event.orderReviewParameters.rate)
                      : e)
                  .toList()
              : state.orders,
        ),
      ),
    );
  }
}
