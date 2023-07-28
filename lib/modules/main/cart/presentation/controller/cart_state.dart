part of 'cart_bloc.dart';

class CartState extends Equatable {
  final int cartItemsNumber;
  final Status cartStatus;
  final List<CartItem> cartItems;
  final double totalPrice;
  final Status addItemStatus;
  final Status changeQuantityStatus;
  final Status deleteItemStatus;

  const CartState({
    this.cartItemsNumber = 0,
    this.cartStatus = Status.sleep,
    this.cartItems = const [],
    this.totalPrice = 0.0,
    this.addItemStatus = Status.sleep,
    this.changeQuantityStatus = Status.sleep,
    this.deleteItemStatus = Status.sleep,
  });

  CartState copyWith({
    int? cartItemsNumber,
    Status? cartStatus,
    List<CartItem>? cartItems,
    Status? addItemStatus,
    Status? changeQuantityStatus,
    Status? deleteItemStatus,
  }) =>
      CartState(
        cartItemsNumber: changeQuantityStatus == Status.loaded ||
                deleteItemStatus == Status.loaded
            ? cartItems!.isEmpty
                ? 0
                : HelperFunctions.refactorCartItemLength(cartItems)
            : cartItemsNumber ?? this.cartItemsNumber,
        cartStatus: cartStatus ?? this.cartStatus,
        cartItems: cartItems ?? this.cartItems,
        totalPrice: cartItems != null
            ? cartItems.isEmpty
                ? 0.0
                : HelperFunctions.getTotalPriceOfCart(cartItems)
            : totalPrice,
        addItemStatus: addItemStatus ?? this.addItemStatus,
        changeQuantityStatus: changeQuantityStatus ?? this.changeQuantityStatus,
        deleteItemStatus: deleteItemStatus ?? this.deleteItemStatus,
      );

  @override
  List<Object?> get props => [
        cartItemsNumber,
        cartStatus,
        cartItems,
        totalPrice,
        addItemStatus,
        changeQuantityStatus,
        deleteItemStatus,
      ];
}
