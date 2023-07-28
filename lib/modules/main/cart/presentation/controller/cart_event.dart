part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetCartItems extends CartEvent {
  final bool cartInit;
  const GetCartItems({this.cartInit=false});
}

class AddItemToCartEvent extends CartEvent {
  final bool prodIsInCart;
  final Product product;
  final CartItemStatistics statistics;
  const AddItemToCartEvent( {
    required this.prodIsInCart,
    required this.product,
    required this.statistics,
  });
}

class GetCartItemsProds extends CartEvent {
  final List<CartItem> items;
  const GetCartItemsProds(this.items);
}

class ChangeQuantityEvent extends CartEvent {
  final CartItemStatistics statistics;
  const ChangeQuantityEvent({required this.statistics});
}

class DeleteItemEvent extends CartEvent{
  final String prodId;
  const DeleteItemEvent({required this.prodId});
}