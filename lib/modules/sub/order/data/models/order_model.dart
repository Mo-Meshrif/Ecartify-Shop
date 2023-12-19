import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../main/cart/data/models/cart_item_model.dart';
import '../../../address/data/models/address_model.dart';
import '../../domain/entities/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.transactionId,
    required super.dateAdded,
    required super.items,
    required super.totalPrice,
    required super.paymentMethod,
    required super.currency,
    required super.promoVal,
    required super.shippingVal,
    required super.itemsPrice,
    required super.shippingType,
    required super.status,
    required super.userAddress,
    super.orderNumber,
  });

  factory OrderModel.fromSnap(DocumentSnapshot snapshot) => OrderModel(
        id: snapshot.id,
        transactionId: snapshot.get('transaction_id'),
        dateAdded: snapshot.get('date_added') is Timestamp
            ? (snapshot.get('date_added') as Timestamp).toDate()
            : DateTime.parse(snapshot.get('date_added')),
        items: List.from(snapshot.get('items'))
            .map((e) => CartItemModel.fromJson(e))
            .toList(),
        totalPrice: snapshot.get('total_price'),
        paymentMethod: snapshot.get('payment_method'),
        currency: snapshot.get('curreny'),
        promoVal: snapshot.get('promo_discount'),
        shippingVal: snapshot.get('shipping_fee'),
        itemsPrice: snapshot.get('items_price'),
        shippingType: snapshot.get('shipping_type'),
        status: snapshot.get('status'),
        userAddress: AddressModel.fromJson(snapshot.get('address')),
      );

  factory OrderModel.fromJson(Map<String,dynamic> json) => OrderModel(
        id: json['id'],
        transactionId: json['transaction_id'],
         dateAdded: json['date_added'] is Timestamp
            ? (json['date_added'] as Timestamp).toDate()
            : DateTime.parse(json['date_added']),
        items: List.from(json['items'])
            .map((e) => CartItemModel.fromJson(e))
            .toList(),
        totalPrice: json['total_price'],
        paymentMethod: json['payment_method'],
        currency: json['curreny'],
        promoVal: json['promo_discount'],
        shippingVal: json['shipping_fee'],
        itemsPrice: json['items_price'],
        shippingType: json['shipping_type'],
        status: json['status'],
        userAddress: AddressModel.fromJson(json['address']),
      );

  Map<String, dynamic> toJson() => {
        'curreny': currency,
        'transaction_id': transactionId,
        'total_price': totalPrice,
        'promo_discount': promoVal,
        'shipping_fee': shippingVal,
        'items_price': itemsPrice,
        'shipping_type': shippingType,
        'status': status,
        'address': userAddress.toModel().toJson(),
        'items': items.map((e) => e.toModel().toJson()).toList(),
        'payment_method': paymentMethod,
      };
}
