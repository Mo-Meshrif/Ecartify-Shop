import 'package:equatable/equatable.dart';

import '../../../../main/cart/domain/entities/cart_item.dart';
import '../../../address/domain/entities/address.dart';
import '../../data/models/order_model.dart';

class OrderEntity extends Equatable {
  final String id,
      transactionId,
      totalPrice,
      paymentMethod,
      currency,
      promoVal,
      shippingVal,
      itemsPrice,
      shippingType,
      status;
  final int orderNumber;
  final Address userAddress;
  final DateTime dateAdded;
  final List<CartItem> items;
  final double rate;

  const OrderEntity({
    this.id = '-1',
    this.transactionId = '',
    required this.dateAdded,
    required this.items,
    required this.totalPrice,
    required this.paymentMethod,
    required this.currency,
    required this.promoVal,
    required this.shippingVal,
    required this.itemsPrice,
    required this.shippingType,
    required this.status,
    required this.userAddress,
    this.orderNumber = -1,
    this.rate = -1,
  });

  OrderEntity copyWith({
    String? id,
    List<CartItem>? items,
    double? rate,
  }) =>
      OrderEntity(
        id: id ?? this.id,
        transactionId: transactionId,
        dateAdded: dateAdded,
        items: items ?? this.items,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        currency: currency,
        promoVal: promoVal,
        shippingVal: shippingVal,
        itemsPrice: itemsPrice,
        shippingType: shippingType,
        status: status,
        userAddress: userAddress,
        orderNumber: orderNumber,
        rate: rate ?? this.rate,
      );

  OrderModel toModel() => OrderModel(
        id: id,
        transactionId: transactionId,
        totalPrice: totalPrice,
        dateAdded: dateAdded,
        items: items,
        paymentMethod: paymentMethod,
        currency: currency,
        promoVal: promoVal,
        shippingVal: shippingVal,
        itemsPrice: itemsPrice,
        shippingType: shippingType,
        status: status,
        userAddress: userAddress,
        rate: rate,
      );

  @override
  List<Object?> get props => [
        id,
        transactionId,
        dateAdded,
        items,
        totalPrice,
        paymentMethod,
        currency,
        promoVal,
        shippingVal,
        itemsPrice,
        shippingType,
        status,
        userAddress,
        orderNumber,
        rate,
      ];
}
