part of 'shop_bloc.dart';

class ShopState extends Equatable {
  final Status bestSellerProdStatus;
  final List<Product> bestSellerProds;
  final Status sliderBanneStatus;
  final List<SliderBanner> sliderBanners;

  const ShopState({
    this.bestSellerProdStatus = Status.sleep,
    this.bestSellerProds = const [],
    this.sliderBanneStatus = Status.sleep,
    this.sliderBanners = const [],
  });
  ShopState copyWith({
    Status? bestSellerProdStatus,
    List<Product>? bestSellerProds,
    Status? sliderBanneStatus,
    List<SliderBanner>? sliderBanners,
  }) =>
      ShopState(
        bestSellerProdStatus: bestSellerProdStatus ?? this.bestSellerProdStatus,
        bestSellerProds: bestSellerProds ?? this.bestSellerProds,
        sliderBanneStatus: sliderBanneStatus??this.sliderBanneStatus,
        sliderBanners: sliderBanners??this.sliderBanners,
      );

  @override
  List<Object?> get props => [
        bestSellerProdStatus,
        bestSellerProds,
        sliderBanneStatus,
        sliderBanners,
      ];
}
