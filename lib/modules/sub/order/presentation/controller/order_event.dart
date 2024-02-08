part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class AddOrderEvent extends OrderEvent {
  final OrderEntity order;
  const AddOrderEvent({required this.order});
}

class GetOrdersEvent extends OrderEvent {
  final OrderParmeters orderParmeters ;
  const GetOrdersEvent({required this.orderParmeters});
}

class GetOrderItemsProds extends OrderEvent {
  final List<OrderEntity> orders;
  const GetOrderItemsProds(this.orders);
}

class AddOrderReviewEvent extends OrderEvent {
  final OrderReviewParameters orderReviewParameters;
  const AddOrderReviewEvent({required this.orderReviewParameters});
}