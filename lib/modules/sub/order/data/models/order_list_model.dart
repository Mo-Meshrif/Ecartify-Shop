import '../../domain/entities/order_list.dart';

class OrderListModel extends OrderList {
  const OrderListModel({
    required super.orders,
    super.lastVisible,
  });
}
