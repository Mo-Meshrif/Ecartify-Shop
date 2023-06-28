part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class GetSliderBannersEvent extends ShopEvent {}

class GetOfferProductsEvent extends ShopEvent {}

class GetBestSellerProductsEvent extends ShopEvent {}

class UpdateShopProductsEvent extends ShopEvent {
  final ProductParameters productParameters;
  const UpdateShopProductsEvent({required this.productParameters});
}