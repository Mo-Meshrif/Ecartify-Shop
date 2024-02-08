part of 'order_bloc.dart';

class OrderState extends Equatable {
  final Status addOrderStatus,
      tempOrderStatus,
      getOrderListStatus,
      addOrderReviewStatus;
  final OrderEntity? tempOrder;
  final List<OrderEntity> orders;
  final bool isOrdersMax;
  const OrderState({
    this.addOrderStatus = Status.sleep,
    this.tempOrderStatus = Status.sleep,
    this.tempOrder,
    this.getOrderListStatus = Status.sleep,
    this.orders = const [],
    this.isOrdersMax = false,
    this.addOrderReviewStatus = Status.sleep,
  });

  OrderState copyWith({
    Status? addOrderStatus,
    Status? tempOrderStatus,
    OrderEntity? tempOrder,
    Status? getOrderListStatus,
    List<OrderEntity>? orders,
    bool? isOrdersMax,
    Status? addOrderReviewStatus,
  }) =>
      OrderState(
        addOrderStatus: addOrderStatus ?? this.addOrderStatus,
        tempOrderStatus: tempOrderStatus ?? this.tempOrderStatus,
        tempOrder: tempOrderStatus == Status.error
            ? null
            : tempOrder ?? this.tempOrder,
        getOrderListStatus: getOrderListStatus ?? this.getOrderListStatus,
        orders: orders ?? this.orders,
        isOrdersMax: isOrdersMax ?? this.isOrdersMax,
        addOrderReviewStatus: addOrderReviewStatus ?? this.addOrderReviewStatus,
      );

  @override
  List<Object?> get props => [
        addOrderStatus,
        tempOrderStatus,
        tempOrder,
        getOrderListStatus,
        orders,
        isOrdersMax,
        addOrderReviewStatus,
      ];
}
