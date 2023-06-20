part of 'shop_bloc.dart';

class ShopState extends Equatable {
  final Status bestSellerProdStatus;
  final List<Product> bestSellerProds;

  const ShopState({
    this.bestSellerProdStatus = Status.sleep,
    this.bestSellerProds = const [],
  });
  ShopState copyWith({
    Status? bestSellerProdStatus,
    List<Product>? bestSellerProds,
  }) =>
      ShopState(
        bestSellerProdStatus: bestSellerProdStatus ?? this.bestSellerProdStatus,
        bestSellerProds: bestSellerProds ?? this.bestSellerProds,
      );

  @override
  List<Object?> get props => [
        bestSellerProdStatus,
        bestSellerProds,
      ];
}
