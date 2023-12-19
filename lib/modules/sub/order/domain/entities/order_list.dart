import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'order.dart';

class OrderList extends Equatable {
  final List<OrderEntity> orders;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastVisible;

  const OrderList({required this.orders, this.lastVisible});

  @override
  List<Object?> get props => [
        orders,
        lastVisible,
      ];
}
