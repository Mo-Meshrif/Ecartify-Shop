part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class GetBestSellerProductsEvent extends ShopEvent {}
class UpdateShopProductsEvent extends ShopEvent{
  final ProductParameters productParameters;
  const UpdateShopProductsEvent({required this.productParameters});
}